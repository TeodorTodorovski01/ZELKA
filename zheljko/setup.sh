#!/usr/bin/env bash
# Build the Jazzy image and create the "turtlebox" podman container.
# All container creation/setup lives here; enter.sh only opens shells into it.
#
# Usage:
#   ./setup.sh                 build image + create container (if not present)
#   ./setup.sh --recreate      remove our existing turtlebox and create it fresh
#   ./setup.sh --rename-old    rename a foreign container named turtlebox to turtlebox-old first
#   ./setup.sh --sim           also install the Gazebo simulator (large download)
#   ./setup.sh --no-build      skip the image build; use an image you already have
#                              (e.g. loaded from USB with: podman load -i turtlebox.tar)
# Options can be combined, e.g.  ./setup.sh --sim --recreate
#
# Requirements: Linux with podman. The image is ~4 GB (about 1.5 GB to download).
set -euo pipefail

NAME=turtlebox
IMAGE=localhost/turtlebox:jazzy
BASE=docker.io/library/ros:jazzy-ros-base
DOMAIN_ID=${ROS_DOMAIN_ID:-0}
RMW=rmw_fastrtps_cpp
HERE=$(cd "$(dirname "$0")" && pwd)

recreate=0; rename_old=0; sim=0; build=1
for arg in "$@"; do
    case "$arg" in
        --recreate)   recreate=1 ;;
        --rename-old) rename_old=1 ;;
        --sim)        sim=1 ;;
        --no-build)   build=0 ;;
        *) echo "unknown option: $arg" >&2; exit 2 ;;
    esac
done

# --- Packages ---------------------------------------------------------------
PACKAGES=(
    # TurtleBot4 / Create 3 interfaces: needed to read /dock_status, /hmi/*, actions
    ros-jazzy-turtlebot4-msgs
    ros-jazzy-irobot-create-msgs
    ros-jazzy-rmw-fastrtps-cpp
    # TurtleBot4 PC software: RViz2 + robot model + view launchers (turtlebot4_viz)
    ros-jazzy-turtlebot4-desktop
    # SLAM, localization and Nav2 launchers for TB4 (slam_toolbox, nav2)
    ros-jazzy-turtlebot4-navigation
    # Driving by hand
    ros-jazzy-teleop-twist-keyboard
    # GUI tools: graph, topics, plots, diagnostics monitor, camera, TF tree
    ros-jazzy-rqt-common-plugins
    ros-jazzy-rqt-robot-monitor
    ros-jazzy-rqt-image-view
    ros-jazzy-rqt-tf-tree
    ros-jazzy-tf2-tools
    # Compressed camera images (/oakd/.../compressed)
    ros-jazzy-image-transport-plugins
    # Web / dashboard bridges: rosbridge (roslibjs) and Foxglove
    ros-jazzy-rosbridge-suite
    ros-jazzy-foxglove-bridge
    # Shell tools
    iputils-ping iproute2 less nano bash-completion
)
(( sim )) && PACKAGES+=(ros-jazzy-turtlebot4-simulator)

command -v podman >/dev/null || { echo "!! podman is not installed (Fedora: preinstalled; Ubuntu: sudo apt install podman)" >&2; exit 1; }

if (( build )); then
echo ">> Building $IMAGE from $BASE $( (( sim )) && echo '(with simulator)')"
podman build -t "$IMAGE" -f - "$HERE" <<EOF
FROM $BASE
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \\
        ${PACKAGES[*]} \\
    && rm -rf /var/lib/apt/lists/*
ENV ROS_DOMAIN_ID=$DOMAIN_ID \\
    RMW_IMPLEMENTATION=$RMW \\
    QT_QPA_PLATFORM=xcb
RUN echo 'source /opt/ros/jazzy/setup.bash' >> /root/.bashrc
EOF
else
    podman image exists "$IMAGE" || { echo "!! --no-build given but image $IMAGE does not exist. Load it or run without --no-build." >&2; exit 1; }
    echo ">> Skipping build, using existing image $IMAGE"
fi

# --- Container ----------------------------------------------------------------
if podman container exists "$NAME"; then
    current=$(podman inspect "$NAME" --format '{{.ImageName}}')
    if [[ "$current" != "$IMAGE" ]]; then
        if (( rename_old )); then
            echo ">> Renaming existing $NAME ($current) to ${NAME}-old"
            podman rename "$NAME" "${NAME}-old"
        else
            echo "!! A container named $NAME already exists from a different image ($current)." >&2
            echo "   Re-run with --rename-old to keep it as ${NAME}-old, or remove it yourself." >&2
            exit 1
        fi
    elif (( recreate )); then
        echo ">> Removing existing $NAME"
        podman rm -f "$NAME"
    else
        if [[ "$(podman inspect "$NAME" --format '{{.Image}}')" != "$(podman image inspect "$IMAGE" --format '{{.Id}}')" ]]; then
            echo "!! $NAME runs an older build of $IMAGE. Close its shells and run ./setup.sh --recreate to update."
        else
            echo ">> $NAME already exists and is up to date."
        fi
        podman start "$NAME" >/dev/null
        exit 0
    fi
fi

echo ">> Creating container $NAME"
# --network host        : ROS 2 discovery must see the robot on the Wi-Fi
# DISPLAY + X11 socket  : GUI apps (rviz2, rqt) open on the laptop screen via Xwayland
# --device /dev/dri     : GPU acceleration for rviz2 / Gazebo
# label=disable         : lets SELinux allow access to the X11 socket and the project folder
# project folder        : mounted at /root/ws, so files you save there stay on your laptop
podman create \
    --name "$NAME" \
    --hostname "$NAME" \
    --network host \
    --security-opt label=disable \
    --device /dev/dri \
    -e DISPLAY="${DISPLAY:-:0}" \
    -e XDG_RUNTIME_DIR=/tmp/runtime-root \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -e ROS_DOMAIN_ID="$DOMAIN_ID" \
    -e RMW_IMPLEMENTATION="$RMW" \
    -v "$HERE":/root/ws \
    -w /root/ws \
    "$IMAGE" sleep infinity

podman start "$NAME" >/dev/null
echo ">> Done. Enter it with ./enter.sh"
