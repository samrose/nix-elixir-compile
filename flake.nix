{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      {
      packages.default = (import ./default.nix)
            { pkgs = nixpkgs.legacyPackages.${system}; };

      devShell = 
      let
      pkgs = nixpkgs.legacyPackages.${system};
      mkShell = nixpkgs.legacyPackages.${system}.mkShell;
      basePackages = with pkgs; [alejandra bat elixir_1_16 entr gnumake overmind jq mix2nix graphviz imagemagick inotify-tools python3 unixtools.netstat];
      hooks = ''
        source .env
        mkdir -p .nix-mix .nix-hex
        export MIX_HOME=$PWD/.nix-mix
        export HEX_HOME=$PWD/.nix-mix
        # make hex from Nixpkgs available
        # `mix local.hex` will install hex into MIX_HOME and should take precedence
        export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
        export LANG=C.UTF-8
        # keep your shell history in iex
        export ERL_AFLAGS="-kernel shell_history enabled"
        # Postgres environment variables

      '';
    in
      mkShell {
        shellHook = hooks;
        buildInputs = basePackages;
        propagatedBuildInputs = basePackages;
      };

      }
    );
}
