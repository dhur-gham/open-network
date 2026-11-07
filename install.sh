#!/usr/bin/env bash
# One-command installer: sets up an Xray VLESS+WebSocket server in Docker
# and prints only the client link. Re-running prints the same link again.
set -euo pipefail

NAME="${NAME:-open-network}"
PORT="${PORT:-8880}"
DIR="${DIR:-/opt/$NAME}"
LOG="/tmp/$NAME-install.log"

[ "$(id -u)" = 0 ] || { echo "Run as root." >&2; exit 1; }

{
  set -x
  if ! command -v docker >/dev/null 2>&1; then
    curl -fsSL https://get.docker.com | sh
  fi
  mkdir -p "$DIR"
  cd "$DIR"
  if [ ! -f .env ]; then
    printf 'UUID=%s\nWS_PATH=/%s\nPORT=%s\n' \
      "$(cat /proc/sys/kernel/random/uuid)" \
      "$(head -c9 /dev/urandom | base64 | tr -dc 'a-z0-9')" \
      "$PORT" > .env
    chmod 600 .env
  fi
  . ./.env
  cat > config.json <<JSON
{
  "log": { "loglevel": "warning" },
  "inbounds": [{
    "port": 8880,
    "protocol": "vless",
    "settings": { "clients": [{ "id": "$UUID" }], "decryption": "none" },
    "streamSettings": { "network": "ws", "wsSettings": { "path": "$WS_PATH" } }
  }],
  "outbounds": [{ "protocol": "freedom" }]
}
JSON
  cat > docker-compose.yml <<YML
services:
  xray:
    image: ghcr.io/xtls/xray-core:latest
    container_name: $NAME
    restart: unless-stopped
    command: ["run", "-config", "/etc/xray/config.json"]
    ports:
      - "$PORT:8880"
    volumes:
      - ./config.json:/etc/xray/config.json:ro
YML
  docker compose up -d --force-recreate
  if command -v ufw >/dev/null 2>&1 && ufw status | grep -q "Status: active"; then
    ufw allow "$PORT/tcp"
  fi
  set +x
} >"$LOG" 2>&1 || { echo "Install failed. Details: $LOG" >&2; exit 1; }

. "$DIR/.env"
IP="$(curl -4 -fsS --max-time 8 https://api.ipify.org || curl -4 -fsS --max-time 8 https://ifconfig.me)"
ENC_PATH="$(printf %s "$WS_PATH" | sed 's|/|%2F|g')"
echo "vless://${UUID}@${IP}:${PORT}?encryption=none&type=ws&path=${ENC_PATH}#${NAME}"
