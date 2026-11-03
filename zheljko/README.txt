TURTLEBOT4 CLASSROOM KIT (ROS 2 Jazzy, podman)
==============================================

Requirements: a Linux laptop with podman, connected to the ASI Wi-Fi.
  Fedora: podman is preinstalled.   Ubuntu: sudo apt install podman

Quick start:
  1. Put these files in a folder and open a terminal there.
  2. ./enter.sh
       The first run builds the ROS 2 container (~1.5 GB download, a few
       minutes). Later runs open a shell immediately. Run it in every new
       terminal you need.
  3. Inside the container, check the robot:
       ros2 node list
       ros2 topic echo --once --qos-reliability best_effort --field percentage /battery_state

Then see commands.txt for everything else: status, sensors, GUI tools,
driving the robot (section 12), and the robot's configuration and admin
(sections 14-20).

Files:
  enter.sh      opens a ROS 2 shell in the "turtlebox" container
  setup.sh      builds/updates the container (enter.sh runs it on first use)
  commands.txt  command reference
