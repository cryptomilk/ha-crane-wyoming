# Home Assistant App Repository for Crane Wyoming

<p align="center">
  <img src="./crane_wyoming/logo.png" alt="Crane Wyoming logo" width="250">
</p>

Home Assistant App repository for [crane-wyoming](https://codeberg.org/cryptomilk/crane-wyoming),
a local, privacy-friendly text-to-speech (TTS) and speech-to-text (ASR)
server written in [Rust](https://www.rust-lang.org/) that speaks the
[Wyoming protocol](https://github.com/OHF-Voice/wyoming).

No cloud. No API keys.

Just state-of-the-art voice models running on your own hardware and plugging
straight into Assist.

## Apps

- [Crane Wyoming](./crane_wyoming): TTS/ASR via the Wyoming protocol on port
  10200. See [crane_wyoming/DOCS.md](./crane_wyoming/DOCS.md) for the full
  user guide.
- [Crane Wyoming (CUDA)](./crane_wyoming_cuda): same app, but built with
  NVIDIA CUDA GPU acceleration. Requires an NVIDIA GPU and the NVIDIA
  Container Toolkit on the host. See
  [crane_wyoming_cuda/DOCS.md](./crane_wyoming_cuda/DOCS.md) for
  prerequisites and setup.

## Supported models

You need at least to download one model. Pick one from the
app's configuration (`default_tts_model` / `default_asr_model`) or drop in
your own under `/share/crane-wyoming/tts/` or `/share/crane-wyoming/asr/`.

Supported models are:


| Model | Kind | Notes |
|---|---|---|
| `qwen3-tts-base` | TTS | Voice cloning via reference audio |
| `qwen3-tts-customvoice-0.6b` | TTS | Predefined speakers, smaller model |
| `qwen3-tts-customvoice-1.7b` | TTS | Predefined speakers, larger model |
| `voxtral` | TTS | 10 languages / 20 voices |
| `qwen3-asr-0.6b` | ASR | Smaller speech-to-text model |
| `qwen3-asr-1.7b` | ASR | Larger speech-to-text model |


The models are all very slow on CPU. You can cache the results in that case.
Support for models which should work just fine CPU is work in progress (like
Kokoro).
See [crane_wyoming/DOCS.md](./crane_wyoming/DOCS.md) for model management
details and performance notes.

## Installation

1. In Home Assistant, go to **Settings** → **Apps** → **App Store**.
2. Click the three-dot menu, choose **Repositories**, and add:
   `https://github.com/cryptomilk/ha-crane-wyoming`
3. Both apps now show up in the store. Install **Crane Wyoming** for CPU-only
   inference, or **Crane Wyoming (CUDA)** if you have an NVIDIA GPU — see
   [crane_wyoming_cuda/DOCS.md](./crane_wyoming_cuda/DOCS.md) for its
   prerequisites before installing.
