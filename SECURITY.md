# Local Toolkit security boundaries

Speech recognition and idle sleep prevention work locally. Audio is held in memory while recording and is not saved by the app. Recognized text is inserted into the currently active application; that application's own network and storage behavior is outside Local Toolkit's control.

The sleep module uses macOS IOPMAssertion APIs only to prevent idle sleep of the system and display. It does not bypass screen lock, explicit sleep, lid closure, or device management policies. Schedules and mode settings are stored in local UserDefaults. On first launch, the app reads settings from the predecessor utility's local preference domain without modifying that utility.

A local diagnostics file records lifecycle and state transitions, with a periodic heartbeat. It contains no audio or transcript text. A missing normal-termination marker indicates that the prior process ended unexpectedly or was stopped externally; it does not by itself prove a crash. macOS crash reports should be used to determine the cause of a specific failure.

GitHub access occurs only when the update button is pressed. Sparkle verifies the signed feed and downloaded archive. The EdDSA private key remains in the local Keychain and is not part of Git or the app archive. The current app bundle uses ad hoc macOS code signing. Apple ties its designated requirement to the build, so microphone and Accessibility access may need to be granted again after updates. A persistent, securely held signing certificate is needed to avoid that; notarized public distribution additionally requires Developer ID signing.

The app is not sandboxed because global keyboard insertion and Accessibility access are required. Network restrictions for managed computers should be enforced by the host policy and independently tested on the released binary.

## Bundled components

- whisper.cpp v1.7.5 and the multilingual Whisper model, with licenses included in the app.
- Sparkle 2.10.0, with its license included in the app.
- The idle sleep module derives from a MIT-licensed utility; its license is included in the app.
