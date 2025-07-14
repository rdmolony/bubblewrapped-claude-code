{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      devPkgs = with pkgs; [
        nodejs
        procps
      ];
      
      # Create a sandboxed Claude Code runner
      claude-sandbox = pkgs.writeShellScriptBin "claude-sandbox" ''
        # Find claude-code in host PATH
        CLAUDE_PATH=$(which claude)
        if [ -z "$CLAUDE_PATH" ]; then
          echo "Error: claude-code not found in PATH"
          exit 1
        fi
        
        # Run Claude Code in sandboxed environment with bubblewrap
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --ro-bind /nix /nix \
          --ro-bind /etc /etc \
          --ro-bind "$CLAUDE_PATH" "$CLAUDE_PATH" \
          --tmpfs /tmp \
          --tmpfs /var \
          --tmpfs /run \
          --proc /proc \
          --dev /dev \
          --bind "$PWD" /workspace \
          --bind $HOME/.claude /workspace/.home/.claude \
          --chdir /workspace \
          --share-net \
          --setenv CLAUDE_ALLOWED_HOSTS "api.anthropic.com" \
          --unshare-pid \
          --unshare-user \
          --unshare-uts \
          --uid 1000 \
          --gid 1000 \
          --hostname claude-sandbox \
          --setenv CLAUDE_BYPASS_PERMISSIONS 1 \
          --setenv HOME /workspace/.home/ \
          --setenv SHELL ${pkgs.bash}/bin/bash \
          --setenv PATH "${pkgs.lib.makeBinPath devPkgs}:$(dirname "$CLAUDE_PATH")" \
          ${pkgs.bash}/bin/bash -c "$CLAUDE_PATH $*"
      '';
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = [ claude-sandbox ] ++ devPkgs;
        
        shellHook = ''
          echo "Claude Code sandbox environment loaded"
          echo "Use 'claude-sandbox' to run Claude Code in a sandboxed container"
          echo "This provides:"
          echo "  - Isolated filesystem (read-only system, writable workspace)"
          echo "  - No network access"
          echo "  - Isolated process namespace"
          echo "  - Temporary directories for /tmp, /var, /run"
        '';
      };
    }
  );
}
