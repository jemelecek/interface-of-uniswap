#!/usr/bin/env bash
set -euo pipefail

# Writes a `.env.testnet` file using values from `rpc-config.json` or direct args.
# Usage:
#   ./set-rpc.sh --chain sepolia --url https://yourrpc.example
#   ./set-rpc.sh --from-config rpc-config.json --network sepolia

OUT_FILE=.env.testnet

usage() {
  cat <<EOF
Usage:
  $0 --chain <chain-key> --url <rpc-url>
  $0 --from-config <file> --chain <chain-key>

Examples:
  $0 --chain sepolia --url https://sepolia.example
  $0 --from-config rpc-config.sample.json --chain mumbai
EOF
  exit 1
}

if [[ $# -eq 0 ]]; then
  usage
fi

CHAIN=""
URL=""
CONFIG_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --chain) CHAIN="$2"; shift 2;;
    --url) URL="$2"; shift 2;;
    --from-config) CONFIG_FILE="$2"; shift 2;;
    --out) OUT_FILE="$2"; shift 2;;
    *) echo "Unknown arg: $1"; usage;;
  esac
done

if [[ -n "$CONFIG_FILE" ]]; then
  if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Config file $CONFIG_FILE not found" >&2; exit 2
  fi
  URL=$(jq -r --arg k "$CHAIN" '.[$k] // empty' "$CONFIG_FILE")
fi

if [[ -z "$URL" ]]; then
  echo "RPC URL is required (use --url or --from-config)" >&2
  exit 3
fi

cat > "$OUT_FILE" <<EOF
# Auto-generated testnet env
RPC_CHAIN=${CHAIN}
RPC_URL=${URL}
EOF

echo "Wrote $OUT_FILE with RPC_CHAIN=$CHAIN"
