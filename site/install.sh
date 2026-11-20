#!/bin/bash
# Study Paws installer for Mac (Apple silicon). Downloads the official disk image and opens it.
# Source: https://github.com/miyagagne/Miya-s-Sandbox
set -e
URL='https://github.com/miyagagne/Miya-s-Sandbox/releases/download/winston-latest/StudyPaws.dmg'
if [ "$(uname -m)" != "arm64" ]; then echo "This download is for Macs with Apple silicon (2020 and newer). Use the web app on this Mac: https://miyagagne.github.io/Miya-s-Sandbox/winston/"; exit 1; fi
OUT="$HOME/Downloads/StudyPaws.dmg"
echo "Downloading Study Paws (about 100 MB)..."
curl -fL --progress-bar -o "$OUT" "$URL"
echo "Opening it. Drag Study Paws into Applications, then open it."
open "$OUT"
