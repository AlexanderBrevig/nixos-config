{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer
            rustfmt
            clippy
            cargo-watch
            cargo-edit
          ];

          shellHook = ''
            echo "🦀 Rust development environment"
            rustc --version
            cargo --version
            export RUST_BACKTRACE=1
          '';
        };
      });
}
