# open-network

One-command self-hosted VLESS over WebSocket server (Xray in Docker). The installer prints the client link when it finishes.

## Install

On a fresh Ubuntu/Debian server, as root. No clone needed:

    curl -fsSL https://raw.githubusercontent.com/dhur-gham/open-network/main/install.sh | bash

It installs Docker if needed, starts the server, opens the port in UFW if active, and prints only the `vless://` link. Running it again prints the same link.

Options (set before the command): `PORT=8880`, `NAME=open-network`, `DIR=/opt/open-network`.

    curl -fsSL https://raw.githubusercontent.com/dhur-gham/open-network/main/install.sh | PORT=8443 bash

## Client

Paste the link into any VLESS client (V2Box, v2rayNG, Streisand, NapsternetV, ...). Transport is WebSocket, no TLS, on the chosen port.

## Update or remove

- Update the image: `cd /opt/open-network && docker compose pull && docker compose up -d`
- Remove: `cd /opt/open-network && docker compose down` and delete the folder.

## Manual setup (optional)

Clone the repo, copy `.env.example` to `.env`, set `UUID` and `WS_PATH`, then run `./deploy.sh`.
