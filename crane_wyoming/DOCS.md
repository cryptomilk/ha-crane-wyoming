# Home Assistant App: Crane Wyoming

## Installation

1. In Home Assistant, go to **Settings** → **Apps** → **App Store**.
2. Click the three-dot menu, choose **Repositories**, and add:
   `https://github.com/cryptomilk/ha-crane-wyoming`
3. Find "Crane Wyoming" in the store and click **Install**.

## Setup

After starting the app, Home Assistant should auto-discover it. It shows up as
a Wyoming integration (TTS and/or ASR), since `discovery: wyoming` is set. If
discovery is disabled or doesn't trigger, add it manually. Go to **Settings** →
**Devices & Services** → **Add Integration** → **Wyoming Protocol**. Point it
at this app's host and port `10200`.

## Configuration

- **Model Path** (`model_path`): Directory containing `tts/` and `asr/` model
  subdirectories. Defaults to `/share/crane-wyoming`. This path persists across
  app reinstalls.
- **Default TTS Model** (`default_tts_model`): Model to download on first run.
  Only applies if `<model_path>/tts` is empty and this isn't `none`.
  Multi-gigabyte downloads only happen if you opt in here.
- **Default ASR Model** (`default_asr_model`): Same idea, but for
  `<model_path>/asr`.
- **CPU Only** (`cpu_only`): Force CPU inference even if a GPU is available.
- **Max Connections** (`max_connections`): Maximum number of concurrent Wyoming
  client connections.
- **Enable TTS Cache** (`tts_cache_enabled`): Cache synthesized audio on disk.
  Speeds up repeated phrases.
- **TTS Cache Max Size** (`tts_cache_max_size`): Maximum size of the on-disk
  TTS cache, e.g. `"500M"` or `"2G"`.
- **Debug Logging** (`debug_logging`): Enable verbose (debug-level)
  logging.

## Model management

Models are opt-in. `default_tts_model` and `default_asr_model` both default to
`none`. A fresh install downloads nothing and starts with an empty model set.

To use a model, either:

- Pick one from **Default TTS Model** / **Default ASR Model** in the app's
  configuration, then restart the app. It downloads into `<model_path>/tts/` or
  `<model_path>/asr/` on first run.
- Or place your own pre-downloaded model directories under
  `/share/crane-wyoming/tts/` or `/share/crane-wyoming/asr/` yourself.  The
  download step never overwrites existing models.

Available models to download:

| Model | Kind | Notes |
|---|---|---|
| `qwen3-tts-base` | TTS | Voice cloning via reference audio |
| `qwen3-tts-customvoice-0.6b` | TTS | Predefined speakers, smaller model |
| `qwen3-tts-customvoice-1.7b` | TTS | Predefined speakers, larger model |
| `voxtral` | TTS | 10 languages / 20 voices |
| `qwen3-asr-0.6b` | ASR | Smaller speech-to-text model |
| `qwen3-asr-1.7b` | ASR | Larger speech-to-text model |

Models are several gigabytes each. Expect the download to take a while on
first run, especially on a slow connection.

## Performance

This app runs CPU-only. Inference speed depends heavily on your hardware.
Expect noticeably slower responses on devices like a Raspberry Pi compared to
a typical x86 machine. If you have an NVIDIA GPU, install
[Crane Wyoming (CUDA)](../crane_wyoming_cuda) instead for GPU-accelerated
inference.

## Port conflict with Piper

Both this app and the official Piper add-on default to Wyoming protocol
port 10200. Each app runs in its own container with its own network
namespace, so there's no actual port conflict. But if you install both, you
can only use one as the active TTS provider per Wyoming integration.
If you plan to do this, change the app's port!

## Support

Please report issues on GitHub:
https://github.com/cryptomilk/ha-crane-wyoming/issues
