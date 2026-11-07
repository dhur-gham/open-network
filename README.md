# open-network

VLESS over WebSocket tunnel (Xray) in a single container.

Setup: copy `.env.example` to `.env`, set `UUID` (e.g. `uuidgen`) and `WS_PATH`, then run `./deploy.sh`.
Client: VLESS, WebSocket, address = server IP, port 8880, no TLS, same UUID and path.
