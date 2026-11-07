#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
git pull --ff-only
set -a; . ./.env; set +a
sed -e "s|__UUID__|${UUID}|" -e "s|__WS_PATH__|${WS_PATH}|" tunnel/config.json.template > tunnel/config.json
cd tunnel && docker compose --env-file ../.env up -d
docker ps --filter name=open-network-xray --format '{{.Names}} {{.Status}}'
