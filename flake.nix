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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        Evie = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix 
            ({ config, pkgs, ...}: {
              # install the overlay
             nixpkgs.overlays = [ alacritty-theme.overlays.default ];
            })
            ({ config, pkgs, ... }: {
              home-manager.users.lukef = hm: {
                programs.alacritty = {
                  enable = true;
                  # use a color scheme from the overlay
                  settings.general.import = [ pkgs.alacritty-theme.gruvbox_material ];
                };
              };
            })
          ];
        };
      };
      homeConfigurations = {
        lukef = home-manager.lib.homeManagerConfiguration {
          inherit pkgs; 
          modules = [ ./home.nix ];
        };
        root = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./root-dotfiles/home.nix ];
        };
      };
    };
}
