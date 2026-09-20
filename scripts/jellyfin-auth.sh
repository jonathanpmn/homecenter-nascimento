#!/usr/bin/env bash
# Emite header Authorization para a API Jellyfin 12+ (usa variável JELLYFIN_TOKEN se definida).
set -euo pipefail

JELLYFIN_URL="${JELLYFIN_URL:-http://127.0.0.1:8096}"
JELLYFIN_USER="${JELLYFIN_USER:-familia}"
JELLYFIN_PASSWORD="${JELLYFIN_PASSWORD:-}"
CLIENT_ID="${JELLYFIN_CLIENT_ID:-home-media-setup}"
DEVICE_NAME="${JELLYFIN_DEVICE:-Mac}"

if [[ -z "$JELLYFIN_PASSWORD" ]]; then
  echo "Defina JELLYFIN_PASSWORD (ex.: export JELLYFIN_PASSWORD='...')" >&2
  exit 1
fi

if [[ -z "${JELLYFIN_TOKEN:-}" ]]; then
  JELLYFIN_TOKEN=$(JELLYFIN_USER="$JELLYFIN_USER" JELLYFIN_PASSWORD="$JELLYFIN_PASSWORD" python3 - <<'PY'
import json, os, urllib.request
url = os.environ.get("JELLYFIN_URL", "http://127.0.0.1:8096") + "/Users/AuthenticateByName"
body = json.dumps({"Username": os.environ["JELLYFIN_USER"], "Pw": os.environ["JELLYFIN_PASSWORD"]}).encode()
req = urllib.request.Request(url, data=body, method="POST")
req.add_header("Content-Type", "application/json")
req.add_header(
    "Authorization",
    'MediaBrowser Client="Jellyfin Web", Device="%s", DeviceId="%s", Version="12.1.0", Token=""'
    % (os.environ.get("JELLYFIN_DEVICE", "Mac"), os.environ.get("JELLYFIN_CLIENT_ID", "home-media-setup")),
)
print(json.load(urllib.request.urlopen(req))["AccessToken"])
PY
)
fi

printf 'MediaBrowser Client="Jellyfin Web", Device="%s", DeviceId="%s", Version="12.1.0", Token="%s"' \
  "$DEVICE_NAME" "$CLIENT_ID" "$JELLYFIN_TOKEN"
