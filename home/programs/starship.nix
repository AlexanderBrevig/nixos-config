{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    
    settings = {
      format = "$username$hostname$directory$git_branch$git_status$cmd_duration$line_break$character";
      
      username = {
        show_always = false;
        format = "[$user]($style)@";
      };
      
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) ";
        style = "bold blue";
      };
      
      directory = {
        truncation_length = 3;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };
      
      git_branch = {
        format = "[$symbol$branch]($style) ";
      };
      
      git_status = {
        format = "([[$all_status$ahead_behind]]($style) )";
      };
      
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      rust = {
        format = "[$symbol($version )]($style)";
      };
      
      go = {
        format = "[$symbol($version )]($style)";
      };
      
      python = {
        format = "[$symbol($version )]($style)";
      };
    };
  };
}
