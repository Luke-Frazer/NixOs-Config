# Overview
This is my NixOs config for my laptop "Evie". It is relatively simple, but uses flakes and home-manager for better organization and stability. 
I recommend forking or copying these files into your own repo so that you can save your own modifications.

# Steps to install
I tried really hard to make the installation and update process as simple and reproducable as possible. 
Just clone all the files in this repo to `$HOME/.dotfiles` so that the folder structure looks like:
- /home/your-user/.dotfiles/configuration.nix
- /home/your-user/.dotfiles/root-dotfiles/*
- etc

Ensure that all but the root-dotfiles directory are owned by your user and root-dotfiles are owned by root. 
Example command to change ownership:
```shell
chown <your-user>:<users-group> <filename>
```

Set your `/etc/nixos/configuration.nix` as a symlink to the `$HOME/.dotfiles/configuration.nix` and set your user to owner.
Example command to set sym link:
```shell
sudo ln -s /home/your-user/.dotfiles/configuration.nix /etc/nixos/configuration.nix
sudo chown <your-user>:<users-group> /etc/nixos/configuration.nix
```

Feel free to do this for hardware-configuration.nix as well if you expect to make changes to that. 
Now, assume root user and create a .dotfiles folder for root:
```shell
sudo su -
mkdir .dotfiles
```

Set a few sym links for the home.nix, vimrc, and p10k.zsh:
```shell
ln -s /home/your-user/.dotfiles/root-dotfiles/home.nix /root/.dotfiles/home.nix
ln -s /home/your-user/.dotfiles/root-dotfiles/vimrc /root/.dotfiles/vimrc
ln -s /home/your-user/.dotfiles/root-dotfiles/p10k.zsh /root/.dotfiles/p10k.zsh
```

Now, set a sym link for flake.nix to your user's flake.nix, since that has a config for both root and your user
```shell
ln -s /home/your-user/.dotfiles/flake.nix /root/.dotfiles/flake.nix
```

Now, just make sure you bootstrap home-manager so that it exists in your system by following the [standalonne install](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone) for both your user and root.

You should be set to rebuild nix and home manager like so:
```shell
nixos-rebuild switch --flake /home/your-user/.dotfiles/
home-manager switch --flake /home/your-user/.dotfiles/
```

This double config of root and your-user ensures that when I assume root, I dont lose my vim settings, powerlevel10k, etc.

# Aliases
I did also add some aliases to ensure that I can quickly update git and the system with a simple command.
Here are a few examples but feel free to check out home.nix for the full list:
`all-git-update`: updates all files in ~/.dotfiles and pushes to git.
`home-update`: updates home-manager's config and pushes home.nix to git.
`nix-update`: updates nixos and pushes nix config files to git. 
`open-home`: opens home.nix in my .dotfiles directory with vim. 
