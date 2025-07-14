# Bubblewrapped Claude Code

A Nix flake that runs Claude Code in a sandboxed environment using bubblewrap.

## Usage

1. Enter the development environment:
   ```bash
   nix develop
   ```

2. Run Claude Code in the sandbox:
   ```bash
   claude-sandbox [args]
   ```

## Security Features

- Isolated filesystem (read-only system, writable workspace only)
- Isolated process namespace
- Temporary directories for `/tmp`, `/var`, `/run`

## Requirements

- Nix with flakes enabled
- Claude Code installed on the host system