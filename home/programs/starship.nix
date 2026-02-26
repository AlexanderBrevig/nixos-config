{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    
    settings = {
      # Catppuccin Mocha palette
      palette = "catppuccin_mocha";

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };

      format = "$username$hostname$directory$git_branch$git_status$cmd_duration$line_break$character";

      username = {
        show_always = false;
        format = "[$user]($style)@";
        style_user = "mauve";
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) ";
        style = "bold blue";
      };

      directory = {
        truncation_length = 3;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold sapphire";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold mauve";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
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
        style = "peach";
      };

      golang = {
        format = "[$symbol($version )]($style)";
        style = "teal";
      };

      python = {
        format = "[$symbol($version )]($style)";
        style = "yellow";
      };
    };
  };
}
