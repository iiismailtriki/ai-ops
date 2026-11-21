#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose exec -T n8n sh -c 'rm -rf /tmp/wf && n8n export:workflow --all --separate --pretty --output=/tmp/wf/'
docker compose cp n8n:/tmp/wf/. workflows/
sed -i -E 's/"name": "[^"]*<[^">]*@[^">]*>"/"name": "Owner <owner@example.com>"/g; s/"chatId": "[0-9]+"/"chatId": "YOUR_TELEGRAM_CHAT_ID"/g' workflows/*.json
if grep -rqE '@gmail\.com|"chatId": "[0-9]+"' workflows/; then echo "PERSONAL DATA FOUND, not clean"; exit 1; fi
echo "export clean"
