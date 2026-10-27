#!/usr/bin/env bash
# Generates the missing Android/iOS scaffolding, applies Mishkat's platform settings and app icons.
# Run once from the project root:  bash scripts/setup.sh
set -euo pipefail

cd "$(dirname "$0")/.."

echo "▶ Generating platform folders (existing files are kept)…"
flutter create --org com.mishkat --project-name mishkat --platforms android,ios .

echo "▶ Fetching packages…"
flutter pub get

PLIST="ios/Runner/Info.plist"
if [[ -f "$PLIST" && -x /usr/libexec/PlistBuddy ]]; then
  echo "▶ Configuring iOS Info.plist (name, background audio, languages)…"
  PB=/usr/libexec/PlistBuddy
  $PB -c "Set :CFBundleDisplayName مِشكاة" "$PLIST" 2>/dev/null || $PB -c "Add :CFBundleDisplayName string مِشكاة" "$PLIST"
  $PB -c "Delete :UIBackgroundModes" "$PLIST" 2>/dev/null || true
  $PB -c "Add :UIBackgroundModes array" -c "Add :UIBackgroundModes:0 string audio" "$PLIST"
  $PB -c "Delete :CFBundleLocalizations" "$PLIST" 2>/dev/null || true
  $PB -c "Add :CFBundleLocalizations array" -c "Add :CFBundleLocalizations:0 string ar" -c "Add :CFBundleLocalizations:1 string en" "$PLIST"
else
  echo "⚠ PlistBuddy not found (not on macOS?). Add these to ios/Runner/Info.plist manually:"
  echo "   UIBackgroundModes = [audio], CFBundleLocalizations = [ar, en], CFBundleDisplayName = مِشكاة"
fi

echo "▶ Generating app icons…"
dart run flutter_launcher_icons

echo "✅ Done. Run: flutter run"
