# TM ROS Driver container

Runtime container envieronment of [TechmanRobotInc/tmr_ros2](https://github.com/TechmanRobotInc/tmr_ros2)

## Supported Packages

- tm_driver
- tm_mod_urdf
- tm_description
- tm_msgs

This repository provides two types of containers.

### 1. Standard Driver (`driver`)

It only contains the core communication nodes.  
`tm_driver` is comipled without MoveIt2 interface.

### 2. MoveIt2 Enabled Driver (`driver-moveit`)

Required when you want to control the robot via MoveIt2 (`FollowJointTrajectory` Action Server).  
`tm_driver` is compiled whith MoveIt2 action interface.

## Usage

Select the appropriate image based on your application needs.

### Run Standard Driver

``` bash
docker run -it ghcr.io/takahiro3d/tmr_ros2_container/driver:humble-latest \
    ros2 run tm_driver tm_driver robot_ip:=<robot_ip_address>
```

### Run MoveIt2 Enabled Driver

``` bash
docker run -it ghcr.io/takahiro3d/tmr_ros2_container/driver-moveit:humble-latest \
    ros2 run tm_driver tm_driver robot_ip:=<robot_ip_address>
```

## For Development (Local Build)

You can build specific targets using the `--target` flag.

### 1. Build Standard Driver

Foxy

``` bash
docker build . --target driver -t tm_driver:foxy --build-arg ROS_DISTRO=foxy --build-arg BRANCH=foxy
```

Humble

``` bash
docker build . --target driver -t tm_driver:humble --build-arg ROS_DISTRO=humble --build-arg BRANCH=humble
```

### 2. Build MoveIt2 Enabled Driver

Foxy

``` bash
docker build . --target driver-moveit -t tm_driver_moveit:foxy --build-arg ROS_DISTRO=foxy --build-arg BRANCH=foxy
```

Humble

``` bash
docker build . --target driver-moveit -t tm_driver_moveit:humble --build-arg ROS_DISTRO=humble --build-arg BRANCH=humble
```
