{ pkgs, ... }:
{
  # Global neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  #programs.neovim.plugins = [

  #];
}
