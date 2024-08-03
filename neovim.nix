{ pkgs, ... }:
{
  # Global neovim configuration
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  #programs.neovim.plugins = [

  #];
}
