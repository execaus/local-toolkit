# Local Toolkit

Local Toolkit is a macOS menu bar app with two local utilities: speech dictation and idle sleep prevention. Speech is processed on the device with the bundled Whisper model. Audio and transcripts are not saved to files. The app contacts GitHub only when the user presses the update button.

## Features

- Dictate into the currently focused field. Double-tap the right Option key to start, tap it once to finish, or hold it for push-to-talk. Esc cancels a recording.
- Choose an input microphone or let the app select the most-used device among those currently connected.
- Correct recognized terms with a local dictionary. Optionally press Enter after a successful insertion.
- Keep the Mac and display awake during idle time, manually, for a timer duration, or on a weekly schedule. System lock, explicit sleep, a closed lid, and device policies still apply.
- Check for signed updates manually from the settings window.

The app keeps its existing bundle identifier for update and permission compatibility. The release provides two archives: `LocalToolkit-0.3.0-manual-macos-arm64.zip` contains `Local Toolkit.app` for manual installation, while `LocalToolkit-0.3.0-macos-arm64.zip` retains the previous bundle filename for Sparkle updates. On first launch, the sleep utility imports locally stored settings from the predecessor app. The predecessor's login item is not changed; disable it separately if it is still installed.

## Build

Requires macOS 14 or later, Swift 6, and Apple Silicon. The model is excluded from Git because of its size. To build from source:

```sh
zsh scripts/fetch-model.sh
zsh scripts/make-app.sh
```

The model download occurs only during a source build and is checksum-checked. Released application archives include the model and run offline. The current build uses an ad hoc code signature. macOS may ask for microphone and Accessibility permission again after an update. A stable signing identity is required to preserve that trust across versions; this machine does not currently have a Developer ID signing identity. Do not treat the Sparkle archive signature as a substitute for macOS code signing.

## Local checks

```sh
dist/LocalDictationSpike.app/Contents/MacOS/LocalDictationSpike --self-check
dist/LocalDictationSpike.app/Contents/MacOS/LocalDictationSpike --settings-check
dist/LocalDictationSpike.app/Contents/MacOS/LocalDictationSpike --sleep-check
codesign --verify --deep --strict dist/LocalDictationSpike.app
```

The local diagnostics file records lifecycle, sleep-state changes, and dictation stages without audio or recognized text. macOS crash reports are stored separately in DiagnosticReports. See [SPEC.md](SPEC.md) and [SECURITY.md](SECURITY.md) for behavior and security boundaries.
