{ config, pkgs, lib, inputs, ... }:

{
  xdg.configFile."helix/runtime/queries/zshot".source = "/home/ab/github.com/tree-sitter-zshot/queries";

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix;
    
    settings = {
      theme = "catppuccin_mocha";
      
      editor = {
        line-number = "relative";
        scrolloff = 5;
        idle-timeout = 0;
        auto-pairs = false;
        color-modes = true;
        cursorline = true;
        true-color = true;
        rulers = [];
        cursor-shape.insert = "bar";
        file-picker.hidden = false;
        lsp.display-messages = true;
        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
        };
      };
    };
    
    languages = {
      grammar = [
        {
          name = "zshot";
          source = {
            git = "https://github.com/AlexanderBrevig/tree-sitter-zshot";
            rev = "eef1ad9881aacb5d8205cd2ffe939c4cfef9d113";
          };
        }
      ];

      language-server = {
        rust-analyzer = {
          command = "rust-analyzer";
          config = {
            checkOnSave = {
              command = "clippy";
            };
          };
        };
        
        gopls = {
          command = "gopls";
        };
        
        typescript-language-server = {
          command = "typescript-language-server";
          args = ["--stdio"];
        };
      };
      
      language = [
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
          };
        }
        {
          name = "go"; 
          auto-format = true;
          formatter = {
            command = "gofumpt";
          };
        }
        {
          name = "python";
          auto-format = true;
        }
        {
          name = "zshot";
          scope = "source.zshot";
          file-types = ["zshot" "inzshot"];
          comment-token = "#";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];
    };
  };
}
