#!/usr/bin/env bash
# Home Assistant apps are independently-built directories — the Docker
# build context for crane_wyoming_cuda/ can't see files outside itself, so
# rootfs/, translations/, and icon.png can't be symlinked to crane_wyoming/.
# crane_wyoming/ is the source of truth; this script copies those three
# items into crane_wyoming_cuda/ so a build can find them.
#
# rootfs/ is gitignored: crane_wyoming_cuda uses a registry image (see its
# config.yaml), so only our own CI/local builds ever need it — run this
# before building locally. translations/ and icon.png ARE committed
# (Supervisor reads them directly from the repo for the App Store listing),
# so after running this, `git status` should show no changes for those two
# unless crane_wyoming/'s copies changed — commit the result if it does.
# CI (.github/workflows/builder.yaml) checks for that drift.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

for item in rootfs translations icon.png; do
    rm -rf "crane_wyoming_cuda/${item}"
    cp -a "crane_wyoming/${item}" "crane_wyoming_cuda/${item}"
done
