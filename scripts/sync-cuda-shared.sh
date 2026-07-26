#!/usr/bin/env bash
# Home Assistant apps are independently-built directories — the Docker
# build context for crane_wyoming_cuda/ can't see files outside itself, so
# rootfs/, translations/, and icon.png can't be symlinked to crane_wyoming/.
# crane_wyoming/ is the source of truth; this script copies those three
# items into crane_wyoming_cuda/. Run it after editing any of them, then
# commit the result. CI (.github/workflows/builder.yaml) fails if the two
# copies drift out of sync.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

for item in rootfs translations icon.png; do
    rm -rf "crane_wyoming_cuda/${item}"
    cp -a "crane_wyoming/${item}" "crane_wyoming_cuda/${item}"
done
