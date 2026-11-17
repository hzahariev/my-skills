#!/usr/bin/env bash
# Render a 1920x1080 story slide (HTML) to PNG with headless Chrome.
#
#   render-story.sh <story.html> <out.png> [scale]
#
# scale 1 gives 1920x1080 for a quick check, scale 2 gives 3840x2160 for the final.
# The HTML loads its fonts from Google Fonts, so the machine needs network access.
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $(basename "$0") <story.html> <out.png> [scale]" >&2
  exit 2
fi

html="$1"
out="$2"
scale="${3:-2}"

if [ ! -f "$html" ]; then
  echo "not found: $html" >&2
  exit 1
fi

chrome=""
for candidate in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  "$(command -v google-chrome || true)" \
  "$(command -v chromium || true)"; do
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then
    chrome="$candidate"
    break
  fi
done

if [ -z "$chrome" ]; then
  echo "Chrome or Chromium is needed to render the slide." >&2
  exit 1
fi

html_abs="$(cd "$(dirname "$html")" && pwd)/$(basename "$html")"
out_dir="$(cd "$(dirname "$out")" && pwd)"
out_abs="$out_dir/$(basename "$out")"

"$chrome" --headless=new --disable-gpu --hide-scrollbars \
  --allow-file-access-from-files \
  --force-device-scale-factor="$scale" \
  --window-size=1920,1080 \
  --virtual-time-budget=8000 \
  --screenshot="$out_abs" "file://$html_abs" >/dev/null 2>&1

if [ ! -s "$out_abs" ]; then
  echo "render failed: $out_abs was not written" >&2
  exit 1
fi

echo "$out_abs"
