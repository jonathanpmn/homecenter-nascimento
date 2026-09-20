#!/usr/bin/env bash
# Descarrega 1 vídeo ou playlist do YouTube para ~/Media/YouTube
# Uso:
#   ./youtube-download.sh "https://www.youtube.com/watch?v=..."
#   ./youtube-download.sh "https://www.youtube.com/playlist?list=..."

set -euo pipefail

MEDIA_ROOT="${MEDIA_ROOT:-$HOME/Media/YouTube}"
URL="${1:-}"

if [[ -z "$URL" ]]; then
  echo "Uso: $0 <URL do YouTube (vídeo ou playlist)>"
  exit 1
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp não encontrado. Instale com: brew install yt-dlp"
  exit 1
fi

mkdir -p "$MEDIA_ROOT"

# Nomes limpos: pasta por canal, título sanitizado, id para evitar colisões
# --restrict-filenames: só ASCII seguro para TVs e Jellyfin
yt-dlp \
  --no-write-playlist-metafiles \
  --embed-metadata \
  --embed-thumbnail \
  --merge-output-format mp4 \
  --restrict-filenames \
  -o "${MEDIA_ROOT}/%(channel)s/%(title).100B [%(id)s].%(ext)s" \
  "$URL"

echo ""
echo "Concluído. Pasta: $MEDIA_ROOT"
echo "No Jellyfin: Biblioteca → Scan (ou aguarde scan automático)."
