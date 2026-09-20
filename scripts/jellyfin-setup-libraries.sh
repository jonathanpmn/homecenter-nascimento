#!/usr/bin/env bash
# Cria bibliotecas padrão no Jellyfin (Séries, Filmes, Kids YouTube) se ainda não existirem.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JELLYFIN_URL="${JELLYFIN_URL:-http://127.0.0.1:8096}"

if [[ -z "${JELLYFIN_PASSWORD:-}" ]]; then
  echo "Uso: JELLYFIN_PASSWORD='sua-senha' $0" >&2
  exit 1
fi

export JELLYFIN_USER="${JELLYFIN_USER:-familia}"
AUTH=$(bash "$ROOT/scripts/jellyfin-auth.sh")

existing() {
  curl -s -H "Authorization: $AUTH" "${JELLYFIN_URL}/Library/VirtualFolders" \
    | python3 -c "import sys,json; print('\n'.join(x['Name'] for x in json.load(sys.stdin)))"
}

add_lib() {
  local name="$1" type="$2" path="$3"
  if existing | grep -Fxq "$name"; then
    echo "OK já existe: $name"
    return 0
  fi
  local enc_path
  enc_path=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$path'))")
  curl -s -o /dev/null -w "Criada %{http_code}: $name\n" -X POST \
    "${JELLYFIN_URL}/Library/VirtualFolders?name=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$name'))")&collectionType=${type}&refreshLibrary=true&paths=${enc_path}" \
    -H "Authorization: $AUTH" \
    -H 'Content-Type: application/json' \
    -d '{"LibraryOptions":{"EnableRealtimeMonitor":true}}'
}

add_lib "Series" "tvshows" "/media/Series"
add_lib "Filmes" "movies" "/media/Movies"
add_lib "Kids YouTube" "homevideos" "/media/Kids/YouTube"

echo ""
echo "Bibliotecas:"
curl -s -H "Authorization: $AUTH" "${JELLYFIN_URL}/Library/VirtualFolders" \
  | python3 -c "import sys,json; [print(f\"  - {x['Name']}: {x['Locations']}\") for x in json.load(sys.stdin)]"
