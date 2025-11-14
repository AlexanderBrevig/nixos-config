# Development environment flake template
# Copy this to your project root as flake.nix and customize as needed
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
            # Choose your language stack:
            
            # Rust project
            # rustc
            # cargo
            # rust-analyzer
            # rustfmt
            # clippy
            
            # Go project  
            # go
            # gopls
            # gofumpt
            
            # Java project
            # openjdk17  # or openjdk11, openjdk21
            # gradle
            # maven
            
            # Flutter project
            # flutter
            # dart
            
            # Python project
            # python311  # or python310, python312
            # python311Packages.pip
            # python311Packages.virtualenv
            
            # OCaml project
            # ocaml
            # dune_3
            # ocaml-lsp
            
            # Node.js project
            # nodejs_20  # or nodejs_18, nodejs_21
            # nodePackages.npm
            # nodePackages.yarn
            
            # C/C++ project
            # gcc
            # clang
            # cmake
            # gdb
            
            # Additional tools as needed
            # just
            # docker
            # kubernetes
            # terraform
          ];
          
          shellHook = ''
            echo "🚀 Development environment loaded!"
            echo "Available tools:"
            
            # Show versions of installed tools
            # rustc --version 2>/dev/null || true
            # go version 2>/dev/null || true
            # java -version 2>/dev/null || true
            # python --version 2>/dev/null || true
            
            # Set up project-specific environment variables
            # export RUST_BACKTRACE=1
            # export GOPATH=$PWD/.go
            # export PATH=$GOPATH/bin:$PATH
          '';
        };
      });
}