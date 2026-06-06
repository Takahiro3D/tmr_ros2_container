# TM ROS Driver container

## Supported package

- tm_driver
- tm_mod_urdf
- tm_description
- tm_msgs

MoveIt2 related packages are not supprored

## Usage

``` bash
docker run -it ghcr.io/takahiro3d/tmr_ros2_container:humble-latest \
    ros2 run tm_driver tm_driver robot_ip:=<robot_ip_address>
```

## For development

Local build

Foxy

``` bash
docker build . -t tm_driver:foxy --build-arg ROS_DISTRO=foxy --build-arg BRANCH=foxy
```

Humble

``` bash
docker build . -t tm_driver:humble --build-arg ROS_DISTRO=humble --build-arg BRANCH=humble
```
