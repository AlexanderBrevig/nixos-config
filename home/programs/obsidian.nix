{ config, pkgs, lib, ... }:

let
  vaultPath = "${config.home.homeDirectory}/vaults/ideaverse";

  obsidian-git = pkgs.fetchFromGitHub {
    owner = "denolehov";
    repo = "obsidian-git";
    rev = "v2.28.0";
    hash = "sha256-KYF4GqbN00HFa4TE4F8nL0JQVqKaLyEWxVDgS4u1haE=";
  };

  dataview = pkgs.fetchFromGitHub {
    owner = "blacksmithgu";
    repo = "obsidian-dataview";
    rev = "0.5.67";
    hash = "sha256-y5TeCLUW+tanePZbRarR3FsLJII8RH2SUIKyJ2FTF+4=";
  };
in
{
  home.packages = [ pkgs.obsidian ];

  home.activation.setupObsidianVault = lib.hm.dag.entryAfter ["writeBoundary"] ''
    VAULT_PATH="${vaultPath}"
    OBSIDIAN_DIR="$VAULT_PATH/.obsidian"

    if [ ! -d "$VAULT_PATH" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "$VAULT_PATH")"
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/minfhs/ideaverse "$VAULT_PATH"
    fi

    $DRY_RUN_CMD mkdir -p "$OBSIDIAN_DIR/plugins/obsidian-git"
    $DRY_RUN_CMD mkdir -p "$OBSIDIAN_DIR/plugins/dataview"

    $DRY_RUN_CMD cp -r ${obsidian-git}/* "$OBSIDIAN_DIR/plugins/obsidian-git/"
    $DRY_RUN_CMD cp -r ${dataview}/* "$OBSIDIAN_DIR/plugins/dataview/"
  '';

  home.file."${vaultPath}/.obsidian/community-plugins.json".text = builtins.toJSON [
    "obsidian-git"
    "dataview"
  ];

  home.file."${vaultPath}/.obsidian/app.json".text = builtins.toJSON {
    vimMode = false;
    showLineNumber = true;
  };
}
