#!/usr/bin/env bash
# Corrige identificação: Everybody Hates Chris (2005) TMDB 252 — não o spin-off animado.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JELLYFIN_URL="${JELLYFIN_URL:-http://127.0.0.1:8096}"
export JELLYFIN_USER="${JELLYFIN_USER:-familia}"

if [[ -z "${JELLYFIN_PASSWORD:-}" ]]; then
  echo "Uso: JELLYFIN_PASSWORD='...' $0" >&2
  exit 1
fi

export AUTH
AUTH=$(bash "$ROOT/scripts/jellyfin-auth.sh")

python3 << 'PY'
import json, os, urllib.parse, urllib.request

base = os.environ["JELLYFIN_URL"]
auth = os.environ["AUTH"]

def api(method, path, data=None):
    req = urllib.request.Request(base + path, method=method)
    req.add_header("Authorization", auth)
    if data is not None:
        req.add_header("Content-Type", "application/json")
        body = json.dumps(data).encode()
    else:
        body = None
    with urllib.request.urlopen(req, body) as resp:
        return resp.status, resp.read()

# Série na pasta Todo Mundo Odeia o Chris
q = urllib.parse.urlencode({
    "Recursive": "true",
    "IncludeItemTypes": "Series",
    "Fields": "Path,ProviderIds,Name",
})
_, raw = api("GET", "/Items?" + q)
items = json.loads(raw).get("Items", [])
item = next((i for i in items if "Todo Mundo Odeia" in (i.get("Path") or "") or "Chris" in (i.get("Name") or "")), None)
if not item:
    raise SystemExit("Série Chris não encontrada em /media/Series")
item_id = item["Id"]
print("Item:", item["Name"], item_id)

search = {
    "ItemId": item_id,
    "SearchInfo": {
        "Name": "Everybody Hates Chris",
        "Year": 2005,
        "ProviderIds": {"Tmdb": "252"},
    },
}
_, raw = api("POST", "/Items/RemoteSearch/Series", search)
match = json.loads(raw)[0]
if match.get("ProviderIds", {}).get("Tmdb") != "252":
    raise SystemExit("Match TMDB errado: " + str(match.get("ProviderIds")))
print("Aplicar:", match["Name"], match["ProductionYear"])

status, _ = api("POST", f"/Items/RemoteSearch/Apply/{item_id}?replaceAllImages=true", match)
print("Apply:", status)
refresh_q = "Recursive=true&MetadataRefreshMode=FullRefresh&ImageRefreshMode=FullRefresh&ReplaceAllMetadata=true"
status, _ = api("POST", f"/Items/{item_id}/Refresh?" + refresh_q)
print("Refresh:", status)
PY
