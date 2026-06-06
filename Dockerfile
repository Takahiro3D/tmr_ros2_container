ARG ROS_DISTRO=humble
ARG BRANCH=humble

# --- Stage 1: Build Stage ---
FROM ros:${ROS_DISTRO}-ros-base AS builder
ARG ROS_DISTRO
ARG BRANCH

ENV COLCON_HOME=/opt/ros/${ROS_DISTRO}

RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ros2_ws/src
RUN git clone -b ${BRANCH} https://github.com/TechmanRobotInc/tmr_ros2.git .

# "custom_package" is ignored in the build stage since it depends opencv
ARG TARGET_PKGS="tm_msgs tm_driver tm_mod_urdf tm_description demo"
ARG SKIP_PKGS="joint_state_publisher_gui rviz2 xacro tm_controllers"

WORKDIR /ros2_ws
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    rosdep update && \
    colcon list --packages-up-to ${TARGET_PKGS} --paths-only > /tmp/target_paths.txt && \
    rosdep install -y --from-paths $(cat /tmp/target_paths.txt) \
        --ignore-src \
        --rosdistro ${ROS_DISTRO} \
        --skip-keys "${SKIP_PKGS}" && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
        --packages-up-to ${TARGET_PKGS}

# --- Stage 2: Runtime Stage ---
FROM ros:${ROS_DISTRO}-ros-core
WORKDIR /ros2_ws

# Copy the built workspace and ROS installation from the builder stage
COPY --from=builder /ros2_ws/install /ros2_ws/install
COPY --from=builder /opt/ros/${ROS_DISTRO} /opt/ros/${ROS_DISTRO}

# Install runtime dependencies using rosdep
RUN apt-get update && apt-get install -y \
    python3-rosdep \
    && rosdep init || true && rosdep update && \
    rosdep install --from-paths install --ignore-src -y \
        --rosdistro ${ROS_DISTRO} \
        --skip-keys "${SKIP_PKGS}" && \
    # Remove unnecessary tools (rosdep) to reduce image size
    apt-get purge -y python3-rosdep && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "-c", "source /ros2_ws/install/setup.bash && exec \"$@\"", "--"]

CMD ["bash"]
