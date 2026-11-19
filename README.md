# Streaming Hub

Flutter prototype for Windows, Android tablets, and Android/Google TV.

## Current state

- Streaming service catalog with YouTube, TV4 Play and SVT Play
- Add HTTPS service URLs, stored locally
- Remote-friendly focusable service tiles (TV navigation needs device testing)
- GitHub Actions builds Windows portable files and Android APK

**Not yet implemented:** embedded playback, ad blocking, DRM integration, TV launcher metadata, Windows installer, release signing, and cross-device sync. Selecting a service currently copies its URL to the clipboard.

## Builds

Open Actions > Build Streaming Hub and choose Run workflow. Download artifacts from the completed run. The Windows artifact is portable, not an EXE installer. Android builds are unsigned with a production key (Flutter default debug signing for release); do not publish them to an app store.

## Development

Install Flutter, then run `flutter create --platforms=android,windows --project-name=streaming_hub .`, `flutter pub get`, and `flutter run`.

Streaming providers may restrict embedded playback and use DRM or server-side ads. No guarantee of ad-free playback.
