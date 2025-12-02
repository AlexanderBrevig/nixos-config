{
  description = "Project development environment";

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
            # Uncomment your language stack:

            # rustc
            # cargo
            # rust-analyzer
            # rustfmt
            # clippy

            # go
            # gopls
            # gofumpt

            # openjdk17
            # gradle
            # maven

            # flutter
            # dart

            # python311
            # python311Packages.pip
            # python311Packages.virtualenv

            # ocaml
            # dune_3
            # ocaml-lsp

            # nodejs_20
            # nodePackages.npm
            # nodePackages.yarn

            # gcc
            # clang
            # cmake
            # gdb

            # just
            # docker
            # kubernetes
            # terraform
          ];
          
          shellHook = ''
            echo "🚀 Development environment loaded!"

            # rustc --version 2>/dev/null || true
            # go version 2>/dev/null || true
            # java -version 2>/dev/null || true
            # python --version 2>/dev/null || true

            # export RUST_BACKTRACE=1
            # export GOPATH=$PWD/.go
            # export PATH=$GOPATH/bin:$PATH
          '';
        };
      });
}
