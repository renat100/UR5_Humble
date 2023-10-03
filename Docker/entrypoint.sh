#! /bin/bash

#Build sorgente ROS
colcon build

set -e

echo "Provided arguments: $@"

exec $@