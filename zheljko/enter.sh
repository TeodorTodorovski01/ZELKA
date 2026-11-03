#!/usr/bin/env bash
# Enter the turtlebox container with a new interactive shell.
# First run: creates it via setup.sh. All creation/setup itself lives in setup.sh.
set -euo pipefail
NAME=turtlebox
IMAGE=localhost/turtlebox:jazzy
HERE=$(cd "$(dirname "$0")" && pwd)

command -v podman >/dev/null || { echo "!! podman is not installed (Ubuntu: sudo apt install podman)" >&2; exit 1; }

if ! podman container exists "$NAME"; then
    if podman image exists "$IMAGE"; then
        echo ">> $NAME not found, creating it from the existing image"
        "$HERE/setup.sh" --no-build
    else
        echo ">> $NAME not found, running setup.sh first (downloads ~1.5 GB, takes a while)"
        "$HERE/setup.sh"
    fi
fi

if podman image exists "$IMAGE" &&
   [[ "$(podman inspect "$NAME" --format '{{.Image}}')" != "$(podman image inspect "$IMAGE" --format '{{.Id}}')" ]]; then
    echo "!! $NAME runs an older image. When no shells are open in it: ./setup.sh --recreate"
fi

[[ "$(podman inspect "$NAME" --format '{{.State.Running}}')" == true ]] || podman start "$NAME" >/dev/null

# Allow GUI apps from the container (rootless podman runs as your user) onto your screen.
# The permission resets at every login, so it is granted here each time.
command -v xhost >/dev/null && [[ -n "${DISPLAY:-}" ]] && xhost +SI:localuser:"$(id -un)" >/dev/null 2>&1 || true

exec podman exec -it "$NAME" bash
