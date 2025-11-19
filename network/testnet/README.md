# Network testnet helpers

This folder provides convenience scripts and templates to run a local testnet node and configure a custom RPC for development and tests.

Files:

- `start-local-node.sh` — starts a local node. Prefers `anvil` (Foundry). Falls back to `npx hardhat node`.
- `set-rpc.sh` — writes a `.env.testnet` file with `RPC_CHAIN` and `RPC_URL` from CLI args or a JSON config.
- `rpc-config.sample.json` — sample mapping from chain keys to RPC endpoints.
- `.env.testnet.sample` — example environment file format.

Quick start:

1. Start a local node (anvil recommended):

```bash
./network/testnet/start-local-node.sh --port 8545
```

2. Create `.env.testnet` pointing to a testnet RPC (or local node):

```bash
# using a direct URL
./network/testnet/set-rpc.sh --chain sepolia --url http://127.0.0.1:8545

# or using the sample config
./network/testnet/set-rpc.sh --from-config network/testnet/rpc-config.sample.json --chain mumbai
```

Notes:
- `set-rpc.sh` reads JSON using `jq`. Install `jq` if you plan to use `--from-config`.
- `start-local-node.sh` will run indefinitely in the foreground; open a new terminal for `set-rpc.sh`.

If you'd like, I can also add convenience `yarn` scripts in the root `package.json` to run these commands.
