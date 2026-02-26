{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    
    shellAliases = lib.mkMerge [
      {
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -la --icons --git";
        la = "eza -la --icons";
        tree = "eza --tree --icons";
        find = "fd";
        grep = "rg";
        top = "btop";
        htop = "btop";
      }
      
      (lib.mkIf config.programs.git.enable {
        g = "git";
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gca = "git commit --amend";
        gp = "git push";
        gl = "git pull";
        gd = "git diff";
        gco = "git checkout";
        gb = "git branch";
        glog = "git log --oneline --graph --all";
      })
      
      {
        rebuild = "sudo nixos-rebuild switch --flake .";
        test-rebuild = "sudo nixos-rebuild test --flake .";
        update = "nix flake update";
        clean = "sudo nix-collect-garbage -d";
        
        j = "just";
        cd = "z";
        
        # Quick navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        
        # Safety nets
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        
        # Docker shortcuts
        d = "docker";
        dc = "docker-compose";
        dps = "docker ps";
        dpa = "docker ps -a";
        di = "docker images";
        dl = "docker logs";
        dex = "docker exec -it";
        drm = "docker rm";
        drmi = "docker rmi";
      }
    ];

    interactiveShellInit = ''
      ${lib.optionalString config.programs.zoxide.enable "zoxide init fish | source"}
      ${lib.optionalString config.programs.starship.enable "starship init fish | source"}

      ${if config.programs.helix.enable then "set -gx EDITOR helix"
        else "set -gx EDITOR nano"}

      set -gx PATH ~/.nix-profile/bin $PATH

      set -gx LS_COLORS (${pkgs.vivid}/bin/vivid generate catppuccin-mocha)

      set -gx FZF_DEFAULT_COMMAND "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git"
      set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
      set -gx FZF_ALT_C_COMMAND "${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git"

      bind \cr 'history | ${pkgs.fzf}/bin/fzf | read -l result; and commandline -- $result'

      function fish_mode_prompt
        switch $fish_bind_mode
          case default
            set_color --bold red
            echo '[N] '
          case insert
            set_color --bold green
            echo '[I] '
          case replace_one
            set_color --bold yellow
            echo '[R] '
          case visual
            set_color --bold brmagenta
            echo '[V] '
        end
        set_color normal
      end

      set fish_greeting
    '';

    functions = {
      mkcd = {
        description = "Create directory and cd into it";
        body = ''
          if test -z "$argv[1]"
            echo "Usage: mkcd <directory>"
            return 1
          end
          mkdir -p "$argv[1]" && cd "$argv[1]"
        '';
      };

      gcl = {
        description = "Git clone and cd into repository";
        body = ''
          if test -z "$argv[1]"
            echo "Usage: gcl <repository-url>"
            return 1
          end
          git clone "$argv[1]"
          set repo_name (basename "$argv[1]" .git)
          if test -d "$repo_name"
            cd "$repo_name"
          end
        '';
      };
      
      ff = {
        description = "Find and edit file with fzf";
        body = ''
          set file (${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git | ${pkgs.fzf}/bin/fzf)
          if test -n "$file"
            $EDITOR "$file"
          end
        '';
      };

      nix-search = {
        description = "Search for packages in nixpkgs";
        body = "nix search nixpkgs $argv";
      };
      
      nix-shell-run = {
        description = "Run command in nix shell with packages";
        body = ''
          if test (count $argv) -lt 2
            echo "Usage: nix-shell-run <package> <command>"
            return 1
          end
          nix shell nixpkgs#$argv[1] -c $argv[2..-1]
        '';
      };

      dev = {
        description = "Enter project development environment";
        body = ''
          if test -f flake.nix
            echo "🚀 Entering development environment..."
            nix develop
          else if test -f shell.nix
            echo "🚀 Entering nix-shell environment..."
            nix-shell
          else if test -f .envrc
            echo "🚀 Direnv detected, allowing..."
            direnv allow
          else
            echo "❌ No development environment found (flake.nix, shell.nix, or .envrc)"
            echo "💡 Run 'init-project <language>' to create one"
          end
        '';
      };

      init-project = {
        description = "Initialize project with development environment";
        body = ''
          if test -z "$argv[1]"
            echo "Usage: init-project <rust|go|ocaml|node|java|generic>"
            return 1
          end

          set lang $argv[1]
          set template_dir ~/github.com/nixos-config/templates

          if test -f flake.nix
            echo "⚠️  flake.nix already exists"
            return 1
          end

          switch $lang
            case rust go ocaml node java generic
              if test -f $template_dir/$lang.nix
                cp $template_dir/$lang.nix flake.nix
                echo "📝 Created $lang flake.nix"
                echo "🚀 Run 'dev' to enter the environment"
              else
                echo "❌ Template not found: $template_dir/$lang.nix"
                return 1
              end
            case '*'
              echo "❌ Unknown language: $lang"
              echo "Available: rust, go, ocaml, node, java, generic"
              return 1
          end
        '';
      };
      
      quick-env = {
        description = "Quickly enter environment with specific packages";
        body = ''
          if test -z "$argv[1]"
            echo "Usage: quick-env <package1> [package2] ..."
            echo "Example: quick-env nodejs python3 go"
            return 1
          end
          
          set packages
          for arg in $argv
            set packages $packages nixpkgs#$arg
          end
          
          echo "🚀 Starting shell with: $argv"
          nix shell $packages
        '';
      };
      
      docker-clean = {
        description = "Clean up Docker containers, images, and volumes";
        body = ''
          echo "Cleaning up Docker resources..."
          docker container prune -f
          docker image prune -f
          docker volume prune -f
          docker network prune -f
          echo "Docker cleanup complete!"
        '';
      };
      
      docker-enter = {
        description = "Enter a running Docker container with bash/sh";
        body = ''
          if test -z "$argv[1]"
            echo "Usage: docker-enter <container-name-or-id>"
            return 1
          end
          
          # Try bash first, fall back to sh
          if docker exec -it "$argv[1]" bash 2>/dev/null
            # bash worked
          else
            docker exec -it "$argv[1]" sh
          end
        '';
      };
      
      docker-logs-follow = {
        description = "Follow logs for a Docker container";
        body = ''
          if test -z "$argv[1]"
            echo "Usage: docker-logs-follow <container-name-or-id>"
            return 1
          end
          docker logs -f "$argv[1]"
        '';
      };
      
      docker-stop-all = {
        description = "Stop all running Docker containers";
        body = ''
          set running (docker ps -q)
          if test -n "$running"
            echo "Stopping all running containers..."
            docker stop $running
          else
            echo "No running containers to stop"
          end
        '';
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git";
    
    colors = {
      "bg+" = "#363a4f";
      "bg" = "#24273a";
      "spinner" = "#f4dbd6";
      "hl" = "#ed8796";
      "fg" = "#cad3f5";
      "header" = "#ed8796";
      "info" = "#c6a0f6";
      "pointer" = "#f4dbd6";
      "marker" = "#f4dbd6";
      "fg+" = "#cad3f5";
      "prompt" = "#c6a0f6";
      "hl+" = "#ed8796";
    };
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
