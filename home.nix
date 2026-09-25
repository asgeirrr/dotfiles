{
  config,
  homeDirectory,
  lib,
  pkgs,
  username,
  ...
}:

{
  home = {
    inherit homeDirectory username;
    stateVersion = "26.05";

    packages = with pkgs; [
      _7zz
      fastfetch
      git-lfs
      htop
      jq
      k9s
      kubectl
      kubectx
      kustomize
      pandoc
      tealdeer
      tig
      universal-ctags
      visidata
      yt-dlp
      zip
    ];

    file = {
      ".ctags".source = ./ctags;
      ".config/home-manager".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles";
      ".git_template".source = ./git_template;
      ".gitignore".source = ./gitignore;
      ".gnupg/gpg-agent.conf".source = ./gnupg/gpg-agent.conf;
      ".gnupg/gpg.conf".source = ./gnupg/gpg.conf;
      ".gnupg/scdaemon.conf".source = ./gnupg/scdaemon.conf;
      ".local/share/fonts/dotfiles".source = ./fonts;
      ".vim".source = ./vim;
    };
  };

  fonts.fontconfig.enable = true;

  programs.delta = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --glob '!.git'";
  };

  programs.git = {
    enable = true;
    includes = [ { path = ./gitconfig; } ];
  };

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      gnumake
      lua-language-server
      unzip
    ];
  };

  programs.ripgrep.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.stylua.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = lib.mkOrder 1000 (builtins.readFile ./zshrc);
  };

  xdg.configFile = {
    "nvim".source = ./nvim;
    "pip/pip.conf".source = ./pip.conf;
  };
}
