#!/usr/bin/env bash
# Mesmo que youtube-download.sh, mas grava em ~/Media/Kids/YouTube
# (útil para biblioteca Kids separada no Jellyfin)

set -euo pipefail

export MEDIA_ROOT="${MEDIA_ROOT:-$HOME/Media/Kids/YouTube}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/youtube-download.sh" "$@"
