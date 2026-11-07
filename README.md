# open-network

VLESS over WebSocket tunnel (Xray) in a single container.

Quick install (run as root on a fresh Ubuntu/Debian server):

    bash install.sh

It installs Docker if needed, starts the server and prints only the `vless://` client link. Re-running prints the same link. Options: `PORT=8880`, `NAME=open-network`.

Manual setup: copy `.env.example` to `.env`, set `UUID` (e.g. `uuidgen`) and `WS_PATH`, then run `./deploy.sh`.
Client: VLESS, WebSocket, address = server IP, port 8880, no TLS, same UUID and path.
