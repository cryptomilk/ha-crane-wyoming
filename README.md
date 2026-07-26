# Home Assistant App Repository: Crane Wyoming

Home Assistant App repository for [crane-wyoming](https://codeberg.org/cryptomilk/crane-wyoming),
a local text-to-speech (TTS) and speech-to-text (ASR) server that speaks the
Wyoming protocol.

## Apps

- [Crane Wyoming](./crane_wyoming) — TTS/ASR via the Wyoming protocol on port
  10200. See [crane_wyoming/DOCS.md](./crane_wyoming/DOCS.md) for the full
  user guide.

## Supported models

Models are opt-in — a fresh install downloads nothing. Pick one from the
app's configuration (`default_tts_model` / `default_asr_model`) or drop in
your own under `/share/crane-wyoming/tts/` or `/share/crane-wyoming/asr/`.

| Model | Kind | Notes |
|---|---|---|
| `qwen3-tts-base` | TTS | Voice cloning via reference audio |
| `qwen3-tts-customvoice-0.6b` | TTS | Predefined speakers, smaller model |
| `qwen3-tts-customvoice-1.7b` | TTS | Predefined speakers, larger model |
| `voxtral` | TTS | 10 languages / 20 voices |
| `qwen3-asr-0.6b` | ASR | Smaller speech-to-text model |
| `qwen3-asr-1.7b` | ASR | Larger speech-to-text model |

See [crane_wyoming/DOCS.md](./crane_wyoming/DOCS.md) for model management
details and performance notes (CPU-only for now).

## Installation

1. In Home Assistant, go to **Settings** → **Apps** → **App Store**.
2. Click the three-dot menu, choose **Repositories**, and add:
   `https://github.com/cryptomilk/ha-crane-wyoming`
3. Find "Crane Wyoming" in the store and click **Install**.
