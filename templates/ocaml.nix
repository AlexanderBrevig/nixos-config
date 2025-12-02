{
  description = "OCaml development environment";

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
            ocaml
            dune_3
            opam
            ocamlPackages.ocaml-lsp
            ocamlPackages.utop
            ocamlPackages.odoc
            ocamlformat
          ];

          shellHook = ''
            echo "🐫 OCaml development environment"
            eval $(opam env)
            ocaml -version
            dune --version
          '';
        };
      });
}
