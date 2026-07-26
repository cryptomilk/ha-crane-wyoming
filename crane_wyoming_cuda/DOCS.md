# Home Assistant App: Crane Wyoming (CUDA)

This is the GPU-accelerated variant of [Crane Wyoming](../crane_wyoming). If
you don't have an NVIDIA GPU, install that app instead.

## Prerequisites

This app only works if all of the following are true:

- The host machine has an NVIDIA GPU from the Ampere generation or newer (RTX
  30-series, RTX 40-series, RTX 50-series, or a datacenter card like
  A100/L4/H100). This app always runs GPU inference in BF16, and BF16
  arithmetic requires compute capability 8.0 (Ampere) or higher.
- The host has an NVIDIA driver installed (version 580 or newer which is
  required by CUDA 13.2).
- The host has the [NVIDIA Container
  Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
  installed, with Docker's `daemon.json` setting `"default-runtime": "nvidia"`
  (or an equivalent `nvidia` runtime the Supervisor's Docker daemon uses by
  default). Home Assistant apps have no way to request `--gpus`/`--runtime`
  themselves, so the host must be configured to hand out GPU access to every
  container by default.

Stock Home Assistant OS does **not** ship NVIDIA drivers or the Container
Toolkit, so this app will not see a GPU there unless the OS image has been
customized to add them (for example via a GPU-enabled HAOS build). It works out
of the box on Home Assistant Supervised or Home Assistant Container installs
where you control the underlying Docker host.

If any of the above isn't true, inference silently falls back to CPU, see
Troubleshooting below.

## Security notice

This app sets `full_access: true`, which grants it the entire host `/dev`
tree (not just the GPU). Home Assistant apps have no narrower mechanism to
request GPU device access alone. This drops the app's security rating from
5 to 1 out of 6. Only install this app if you accept that trade-off; the
CPU-only [Crane Wyoming](../crane_wyoming) app keeps the full 5/6 rating.

## Installation

1. In Home Assistant, go to **Settings** → **Apps** → **App Store**.
2. Click the three-dot menu, choose **Repositories**, and add:
   `https://github.com/cryptomilk/ha-crane-wyoming`
3. Find "Crane Wyoming (CUDA)" in the store and click **Install**.

## Setup

After starting the app, Home Assistant should auto-discover it. It shows up as
a Wyoming integration (TTS and/or ASR), since `discovery: wyoming` is set. If
discovery is disabled or doesn't trigger, add it manually. Go to **Settings** →
**Devices & Services** → **Add Integration** → **Wyoming Protocol**. Point it
at this app's host and port `10200`.

## Configuration

Options are identical to the CPU app:

- **Model Path** (`model_path`): Directory containing `tts/` and `asr/` model
  subdirectories. Defaults to `/share/crane-wyoming`. This path persists across
  app reinstalls.
- **Default TTS Model** (`default_tts_model`): Model to download on first run.
  Only applies if `<model_path>/tts` is empty and this isn't `none`.
- **Default ASR Model** (`default_asr_model`): Same idea, but for
  `<model_path>/asr`.
- **CPU Only** (`cpu_only`): Force CPU inference even though this app has a
  GPU-capable binary. Useful for troubleshooting or comparing performance.
- **Max Connections** (`max_connections`): Maximum number of concurrent Wyoming
  client connections.
- **Enable TTS Cache** (`tts_cache_enabled`): Cache synthesized audio on disk.
- **TTS Cache Max Size** (`tts_cache_max_size`): Maximum size of the on-disk
  TTS cache, e.g. `"500M"` or `"2G"`.
- **Debug Logging** (`debug_logging`): Enable verbose (debug-level) logging.

See [crane_wyoming/DOCS.md](../crane_wyoming/DOCS.md) for model management
details — they're identical for both apps.

## Verifying GPU is detected

Check the app's log tab after startup. A successful GPU detection logs the
selected device, e.g. `Device: Cuda(...)`. If it instead logs `Device: Cpu`,
the GPU wasn't picked up — see Troubleshooting.

## Troubleshooting

- **Logs show `Device: Cpu` despite having an NVIDIA GPU**: Verify `nvidia-smi`
  works on the host. Confirm the NVIDIA Container Toolkit is installed and
  Docker's default runtime is `nvidia` (`docker info | grep -i runtime`).
  Restart the Docker daemon after changing
  `daemon.json`.
- **App fails to start**: Check that the NVIDIA driver version is compatible
  with CUDA 13.2 (driver >= 580). Check the app's log for the specific error.
- **Want to rule out GPU issues**: Set `cpu_only: true` and restart — if the
  app then works normally, the problem is GPU/driver related, not the app
  itself.

## Building for a different GPU generation

The published `ghcr.io` image is compiled for compute capability 80 (Ampere,
the minimum this app supports — see Prerequisites). Its CUDA kernels also carry
embedded PTX for that target, so the driver can JIT-compile them forward onto
newer cards (Ada/Hopper/Blackwell) the first time they run, though without
architecture-specific optimizations for those newer cards.

If you want a build tuned for your exact GPU, build the image yourself with
`CUDA_COMPUTE_CAP` set to your card's compute capability (find it via
`nvidia-smi --query-gpu=compute_cap --format=csv` on the host, or the [CUDA GPU
list](https://developer.nvidia.com/cuda-gpus)):

```console
$ podman build \
    --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:bookworm \
    --build-arg CUDA_VERSION=13-2 \
    --build-arg CUDA_COMPUTE_CAP=89 \
    -t ha-crane-wyoming-cuda \
    crane_wyoming_cuda/
```

## Support

Please report issues on GitHub:
https://github.com/cryptomilk/ha-crane-wyoming/issues
