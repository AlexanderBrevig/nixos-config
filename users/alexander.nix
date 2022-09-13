impermanence: { pkgs, ... }:
let
  dirs = {
    defaults = ../defaults;
    colorschemes = ../colorschemes;
    overlays = ../overlays;
  };

  configs = {
    fish = import (dirs.defaults + /fish) { inherit pkgs; };
    ssh = import (dirs.defaults + /ssh);
    git = import (dirs.defaults + /git) { inherit pkgs; };
    sway = import (dirs.defaults + /sway) { inherit pkgs; };
    kitty = import (dirs.defaults + /kitty);
    firefox = import (dirs.defaults + /firefox) { inherit pkgs; };
    gpg = import (dirs.defaults + /gpg);
    gtk = import (dirs.defaults + /gtk) { inherit pkgs; };
    fzf = import (dirs.defaults + /fzf);
    lazygit = import (dirs.defaults + /lazygit);
  };
in
{
  imports = [ impermanence ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # fish shell
  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
  } // configs.fish;

  programs.gh = {
    enable = true;
    settings = {
      editor = "hx";
      git_protocol = "ssh";
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alexander";
  home.homeDirectory = "/home/alexander";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    tree
    curl
    neofetch
    dnsutils
    traceroute
    nmap
    ipcalc
    slack
    jetbrains-mono
    xdg-utils
    swaylock
    swayidle
    wl-clipboard
    grim
    slurp
    wf-recorder
    wdisplays
    wofi
    google-chrome
    file
    aspell
    aspellDicts.en
    git-crypt
    ripgrep
    imv
    bat
    killall
    bitwarden
    bitwarden-cli
    nixfmt
    nix-prefetch-github
    clipman
    gnome3.adwaita-icon-theme
    edge.discord
    unstable.spotify
    unstable.element-desktop
    unstable.wireshark
    fd
    tree-sitter
    fastmod
    hexyl
    asciinema
    tokei
    unstable.exa
    unstable.linuxPackages-libre.perf
  ];

  home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";

  programs.ssh = {
    enable = true;
  } // configs.ssh;

  programs.git = {
    package = pkgs.unstable.git;
    enable = true;
  } // configs.git;

  programs.waybar = {
    enable = true;
  };
  # taking manual control of the waybar config since nix tells me the config
  # is wrong
  xdg.configFile."waybar/config".source = (dirs.defaults + /waybar/config.json);
  xdg.configFile."waybar/style.css".source = (dirs.defaults + /waybar/style.css);
  # wofi styling and config
  xdg.configFile."wofi/config".source = (dirs.defaults + /wofi/config);
  xdg.configFile."wofi/style.css".source = (dirs.defaults + /wofi/style.css);

  xdg.configFile."helix/config.toml".source = (dirs.defaults + /helix/config.toml);

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';

  xdg.configFile."tree-sitter/config.json".source = (dirs.defaults + /tree-sitter/config.json);

  ## Persistence config.
  # The root file-system is a tmpfs: volatile memory that is
  # wiped on reboot. So we need to explicitly declare what to persist across
  # reboots. These files/directories are mounted from non-volatile memory.
  # In modules/common.nix we declare the system-level persisted directories.
  home.persistence."/nix/persist/home/alexander" = {
    directories = [
      # Misc docs.
      "Documents"
      # == Top-level dots ==
      # Source code. This is essentially a cache since everything is a git repo.
      "src"
      # GPG keys and metadata.
      ".gnupg"
      # SSH keys and config.
      ".ssh"
      # hex.pm caches, downloaded library tarballs, auth etc.
      ".hex"
      # cargo cache (Rust)
      ".cargo/registry"
      ".cargo/bin"
      ".cargo/git"
      # == Local state ==
      # Fish history and completions
      ".local/share/fish"
      # Repl history and trusted settings
      ".local/share/nix"
      # Z (fish jump util) database
      ".local/share/z"
      # direnv allowlist
      ".local/share/direnv"
      # == Config ==
      # Most apps in this category abuse the config dir to store state.
      ".config/Slack"
      ".config/discord"
      ".config/chromium"
      ".config/Element"
      ".config/spotify"
      ".config/Bitwarden"
      # == Cache ==
      ".cache/nix"
      ".cache/google-chrome"
      ".cache/yarn"
      ".cache/spotify"
      ".cache/nix-index"
      ".cache/fontconfig"
    ];
    files = [
      # Lazygit repository history
      # ".config/lazygit/state.yml"
      # Fish universal variables
      ".config/fish/fish_variables"
      # Nix cache config
      ".config/nix/nix.conf"
      # GitHub CLI auth
      ".config/gh/hosts.yml"
      # Asciinema installation ID that links to your account
      ".config/asciinema/install-id"
      # wofi (picker) history
      ".cache/wofi-drun"
      ".cache/wofi-dmenu"
    ];
    # > allows other users, such as `root`, to access files through the bind
    # > mounted directories listed in `directories`.
    allowOther = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/chrome" = "google-chrome.desktop";
      "text/html" = "google-chrome.desktop";
      "application/x-extension-htm" = "google-chrome.desktop";
      "application/x-extension-html" = "google-chrome.desktop";
      "application/x-extension-shtml" = "google-chrome.desktop";
      "application/xhtml+xml" = "google-chrome.desktop";
      "application/x-extension-xhtml" = "google-chrome.desktop";
      "application/x-extension-xht" = "google-chrome.desktop";
      "application/pdf" = "google-chrome.desktop";
      "application/x-bzpdf" = "google-chrome.desktop";
      "application/x-gzpdf" = "google-chrome.desktop";
      "application/x-xzpdf" = "google-chrome.desktop";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
  } // configs.sway;

  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
  } // configs.kitty;

  programs.google-chrome = {
    enable = true;
  } // configs.google-chrome;

  services.virtualisation.docker.enable = true;

  services.gpg-agent = {
    enable = true;
  } // configs.gpg;

  gtk = {
    enable = true;
  } // configs.gtk;

  programs.fzf = {
    enable = true;
  } // configs.fzf;

  programs.lazygit = {
    enable = true;
  } // configs.lazygit;

  # build an index of available packages within nixpkgs
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
