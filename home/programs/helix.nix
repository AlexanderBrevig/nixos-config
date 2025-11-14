# Helix editor configuration
{ config, pkgs, lib, inputs, ... }:

{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.helix;
    
    settings = {
      theme = "onedark";
      
      editor = {
        line-number = "relative";
        mouse = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        
        file-picker = {
          hidden = false;
        };
        
        indent-guides = {
          render = true;
        };
        
        soft-wrap = {
          enable = true;
        };
        
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
      
      keys.normal = {
        # Quick save
        "C-s" = ":write";
        
        # Quick quit
        "C-q" = ":quit";
        
        # Navigate between windows
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down"; 
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";
        
        # File picker
        "space f" = "file_picker";
        
        # Buffer picker
        "space b" = "buffer_picker";
        
        # Symbol picker
        "space s" = "symbol_picker";
      };
    };
    
    languages = {
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
      ];
    };
  };
}