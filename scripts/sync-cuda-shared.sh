#!/usr/bin/env bash
# Home Assistant apps are independently-built directories — the Docker
# build context for crane_wyoming_cuda/ can't see files outside itself, so
# rootfs/, translations/, and icon.png can't be symlinked to crane_wyoming/.
# crane_wyoming/ is the source of truth; this script copies those three
# items into crane_wyoming_cuda/ so a build can find them.
#
# These copies are gitignored, not committed: end users never build the
# Containerfile themselves (HA Supervisor pulls prebuilt images from the
# registry), so this only needs to run before CI builds and local dev
# builds. CI (.github/workflows/builder.yaml) runs this before building
# crane_wyoming_cuda; for a local podman/docker build, run it yourself
# first.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

for item in rootfs translations icon.png; do
    rm -rf "crane_wyoming_cuda/${item}"
    cp -a "crane_wyoming/${item}" "crane_wyoming_cuda/${item}"
done
