#!/usr/bin/env bash
set -euo pipefail

# Start a local Ethereum node for testing. Prefers `anvil` if available, falls back to Hardhat.
# Usage: ./start-local-node.sh [--port 8545] [--mnemonic "your mnemonic"]

PORT=8545
MNEMONIC="test test test test test test test test test test test junk"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port) PORT="$2"; shift 2;;
    --mnemonic) MNEMONIC="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

if command -v anvil >/dev/null 2>&1; then
  echo "Starting anvil on port $PORT..."
  anvil -p "$PORT" --mnemonic "$MNEMONIC"
else
  if command -v npm >/dev/null 2>&1; then
    echo "anvil not found — starting Hardhat node via npm (requires hardhat in workspace)."
    # Run in repo root to use workspace hardhat if present
    npx hardhat node --port "$PORT"
  else
    echo "Neither anvil nor npm/Hardhat available. Install Foundry (anvil) or Hardhat." >&2
    exit 2
  fi
fi
