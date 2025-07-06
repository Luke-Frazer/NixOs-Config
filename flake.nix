{
  description = "My first flake!";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs = {self, nixpkgs, home-manager, alacritty-theme, ... }:
    let
      lib = nixpkgs.lib;
      home-lib = home-manager.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ alacritty-theme.overlays.default ];
      };
    in {
      nixosConfigurations = {
        Evie = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };
      homeConfigurations = {
        lukef = home-lib.homeManagerConfiguration {
          inherit pkgs; 
          modules = [ ./home.nix ];
        };
        root = home-lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./root-dotfiles/home.nix ];
        };
      };
    };
}
