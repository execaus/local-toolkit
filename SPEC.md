# Local Toolkit specification

Local Toolkit is a native macOS 14+ menu bar application for Apple Silicon. Its current modules are offline speech dictation and idle sleep prevention. The settings window groups the modules into separate sections.

## Speech dictation

- A configurable global shortcut starts and stops recording. The default right Option gesture supports double-tap start, single-tap finish, and hold-to-record. Esc cancels without recognition or insertion.
- The app records from a selected microphone or chooses the most frequently used device among the available inputs when the device set changes.
- Recognition uses the bundled multilingual Whisper model. Long recordings are split into sequential overlapping chunks so processing reaches the end of the audio. Silence between phrases does not end the job.
- A local dictionary applies literal spelling corrections after recognition. Text is inserted into the active field through a keyboard event. If insertion fails, the result remains available for retry or manual copy.
- Optional Enter submission is off by default. It is sent only after a successful normal insertion, never after a retry.

## Idle sleep prevention

- The app creates system and display idle-sleep assertions when the mode is active, and releases them when inactive.
- Modes: manual until stopped, timer from 1 to 10,080 minutes, and multiple weekly schedules. An interval may cross midnight.
- Stopping an active scheduled interval suppresses it until its end. Future intervals can activate normally.
- The app recalculates state after wake, screen wake, calendar or time-zone changes, and periodically while running.
- Launch at login is optional and configured with the macOS service-management API. It is not a crash-restart service.

## Privacy and updates

Audio, transcripts, dictionary entries, microphone-use counts, schedules, and diagnostics stay on the Mac. Only an explicit update check accesses GitHub. The release feed and archive use Sparkle EdDSA signatures. macOS privacy permissions also depend on the application's code-signing identity; the current ad hoc signature does not keep a stable identity between releases.

## Acceptance checks

- Build and package validation pass, including deep code-signature verification of the extracted app.
- A background-posted wake notification is delivered safely to the main actor.
- Sleep assertions can be created and released locally; timer and overnight schedule cases pass self-checks.
- Synthetic recordings with speech near the beginning, middle, and end of a 15-minute file are all transcribed.
- No audio, transcript, private signing key, or diagnostic log is included in the public release archive.
