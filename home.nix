{ config, pkgs, ... }:

let
  myAliases = {
    # ll = "ls -l";
    ".." = "cd ..";
    "nix-git-update" = "cd /home/lukef/.dotfiles/ && git add configuration.nix && git commit -m 'Updating configuration.nix' && git push origin HEAD && cd -";
    "nix-update" = "nix-git-update && sudo nixos-rebuild switch --flake /home/lukef/.dotfiles/";
    "nix-update-test" = "nix-git-update && sudo nixos-rebuild test --flake /home/lukef/.dotfiles/";
    "nix-update-boot" = "nix-git-update && sudo nixos-rebuild boot --flake /home/lukef/.dotfiles/";
    "home-git-update" = "cd /home/lukef/.dotfiles/ && git add home.nix && git commit -m 'Updating home.nix' && git push origin HEAD && cd -";
    "home-update" = "home-git-update && home-manager switch --flake /home/lukef/.dotfiles/";
    "open-nix" = "sudo vim /home/lukef/.dotfiles/configuration.nix";
    "open-home" = "vim /home/lukef/.dotfiles/home.nix";
    "open-flake" = "vim /home/lukef/.dotfiles/flake.nix";
    "all-git-update" = "cd /home/lukef/.dotfiles/ && git add * && git commit -m 'Updating *all config files' && git push origin HEAD";
  };
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lukef";
  home.homeDirectory = "/home/lukef";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello
    zsh-powerlevel10k

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".p10k.zsh".text = builtins.readFile ./p10k.zsh;
    ".vimrc".text = builtins.readFile ./vimrc;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lukef/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    bash = {
      enable = true;
      shellAliases = myAliases;
    };

    zsh = {
      enable = true;
      shellAliases = myAliases;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true; 
        extraConfig = builtins.readFile ".dotfiles/zshrc-extras";

        plugins = [];
      };
    };
    git = {
      enable = true;
      extraConfig = {
        user.name = "Luke-Frazer";
        user.email = "luke.e.frazer@gmail.com";
        init.defaultBranch = "main";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
