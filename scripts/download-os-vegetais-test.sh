#!/usr/bin/env bash
# Playlist de teste: Os Vegetais (dublagem BR / conteúdo bíblico infantil)
# https://www.youtube.com/playlist?list=PLnBsVzCsa68HiphOTSCggcKqG6Fn3Z7iT
# Muitos vídeos da playlist estão indisponíveis no YouTube; este script
# descarrega entradas que costumam funcionar + blocos da playlist.

set -euo pipefail

DEST="${DEST:-$HOME/Media/Kids/YouTube/Os Vegetais - Desenho Biblico}"
PLAYLIST='https://www.youtube.com/playlist?list=PLnBsVzCsa68HiphOTSCggcKqG6Fn3Z7iT'

mkdir -p "$DEST"

yt-dlp --ignore-errors \
  --merge-output-format mp4 \
  --restrict-filenames \
  --no-write-playlist-metafiles \
  -o "${DEST}/%(playlist_index)02d - %(title).80B [%(id)s].%(ext)s" \
  --playlist-items 10,17 \
  "$PLAYLIST"

# Episódios avulsos (fora da playlist) que estavam disponíveis no teste:
yt-dlp --ignore-errors \
  --merge-output-format mp4 \
  --restrict-filenames \
  -o "${DEST}/%(title).80B [%(id)s].%(ext)s" \
  'https://www.youtube.com/watch?v=uiUL98KJO9s' \
  'https://www.youtube.com/watch?v=5nNnqdJNcq4' \
  'https://www.youtube.com/watch?v=I2qwa_2MFPE'

echo "Ficheiros em: $DEST"
