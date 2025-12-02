# Development Environment Templates

Language-specific Nix flake templates for quick project setup.

## Available Templates

- **rust.nix** - Rust with cargo, clippy, rust-analyzer, cargo-watch
- **go.nix** - Go with gopls, gofumpt, golangci-lint
- **ocaml.nix** - OCaml 5.3 with dune, opam, utop, ocamlformat
- **node.nix** - Node.js 22 with npm, pnpm, TypeScript, ESLint
- **java.nix** - Java 21 with Maven, Gradle, JDT language server
- **generic.nix** - Multi-language template with commented options

## Usage

From your project directory:

```bash
# Initialize a new project with a language template
init-project rust   # or go, ocaml, node, java

# Enter the development environment
dev
```

## Manual Usage

You can also copy templates manually:

```bash
cp ~/github.com/nixos-config/templates/rust.nix ./flake.nix
nix develop
```

## Customization

Each template includes:
- Language toolchain
- Common development tools
- LSP for editor integration
- Formatters and linters
- Helpful shell hook with version info
