  let
    nixvim = import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    });
  in
  { imports = [nixvim.nixosModules.nixvim];
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    globals.mapleader = " ";
    viAlias = true;
    defaultEditor = true;
    vimAlias = true;
    opts = {
      number = true;
      relativenumber = true; 
      winborder = "rounded";
