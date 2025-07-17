# Bubblewrapped Claude Code

A Nix flake that runs Claude Code in a sandboxed environment using bubblewrap.

> [!WARNING]
> Bubblewrap does not yet support restricting internet access to specific servers. Ideally, one should be able to restrict `Claude Code` to only the Claude API to restrict it's network access. `Bubblewrap` allows either full network access with `--share-net` or blocks all network access by omitting `--share-net`.

> [!NOTE]
> Why?
> If you want to run Claude Code with `--dangerously-skip-permissions` Anthropic recommend sandboxing -
>> WARNING: Claude Code running in Bypass Permissions mode  
>> In Bypass Permissions mode, Claude Code will not ask for your approval before running potentially dangerous commands. This mode should only be used in a sandboxed container/VM that has restricted internet access and can easily be restored if damaged. By proceeding, you accept all responsibility for actions taken while running in Bypass Permissions mode https://docs.anthropic.com/s/claude-code-security

## Installation

If you don't have Nix installed, you can install it using [the Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer) which enables flakes by default:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

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
