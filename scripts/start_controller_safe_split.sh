#!/bin/bash
source /home/unitree/core_ws/install/setup.sh
ros2 launch h12_ros2_controller robot_safety_launch.py config:=safety_split safety_config:=default_safety_split.py
