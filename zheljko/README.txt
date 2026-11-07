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
  ../NAVI_TEST  supervised autonomous frontier mapping; saves maps under maps/

Mapping with NAVI_TEST:
  Inside the container, run:
       /root/ws/NAVI_TEST
  For an existing turtlebox created before this script was moved to the repo
  root, close its shells and run `./setup.sh --recreate` from this folder to
  apply the updated repo-root mount (this recreates the container).
  The script requires /scan, /odom, and /hazard_detection. It asks you to type
  START before moving, starts TurtleBot 4 SLAM and Nav2, explores reachable
  frontiers at a maximum linear speed of 0.1 m/s, and saves each run in
  /root/ws/maps/AutoMap_N/ as a map and route.csv (timestamped odometry path).
  After normal completion it navigates back to its starting pose and requests
  the Create 3 /dock action. Start near the dock after manually undocking so
  Create 3 can complete the final docking maneuver. Return/docking is best
  effort, not guaranteed; verify /dock_status. An interrupted or safety-stopped
  run saves its current map and trail but does not automatically return/dock.
  The OAK-D camera is not fused by stock TurtleBot 4 SLAM; mapping uses /scan
  and odometry/TF. Stay beside the robot and keep its stop control accessible;
  do not run near stairs, people, or unprotected edges. Press Ctrl+C to stop
  exploration; this cancels goals and saves the map and trail.
