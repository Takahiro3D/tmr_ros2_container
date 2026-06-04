# TM ROS Driver container

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
