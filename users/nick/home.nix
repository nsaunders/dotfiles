{pkgs, ...}: {
  home.stateVersion = "22.11";

  home.username = "nick";
  home.homeDirectory = "/home/nick";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["caps:swapescape"];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        monospace-font-name = "MesloLGS NF";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
        left-handed = true;
      };
    };
  };

  home.packages = with pkgs; [
    _1password-gui
    alejandra
    direnv
    discord
    git-crypt
    hunspell
    hunspellDicts.en_US
    libreoffice
    meslo-lgs-nf
    pinentry.gnome3
  ];

  home.file.".p10k.zsh".source = ./.p10k.zsh;

  programs.chromium = {
    enable = true;
    commandLineArgs = ["--incognito" "--force-dark-mode"];
    extensions = [
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";}
    ];
  };

  programs.git = {
    enable = true;
    userName = "Nick Saunders";
    userEmail = "nick@saunde.rs";
    lfs = {
      enable = true;
    };
    extraConfig = {
      pull.rebase = true;
      submodule.recurse = true;
    };
  };

  programs.gpg.enable = true;

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set shiftwidth=2 smarttab expandtab tabstop=4 softtabstop=0
    '';
  };

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      "alejandra.program" = "alejandra";
      "editor.formatOnSave" = true;
      "editor.fontFamily" = "MesloLGS NF";
      "editor.fontSize" = 14;
      "editor.detectIndentation" = false;
      "editor.insertSpaces" = true;
      "editor.tabSize" = 2;
      "files.insertFinalNewline" = false;
      "keyboard.dispatch" = "keyCode";
      "terminal.integrated.fontFamily" = "MesloLGS NF";
      "terminal.integrated.fontSize" = 14;
      "vim.startInInsertMode" = false;
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Default Dark+";
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
      };
    };
    extensions = with pkgs.vscode-extensions;
      [
        kamadorueda.alejandra
        vscodevim.vim
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        bbenoist.nix
        haskell.haskell
        justusadam.language-haskell
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "inline-html";
          publisher = "pushqrdx";
          version = "0.3.7";
          sha256 = "sha256-fpF6q5KJLV5vCFysA9qun0mZAAslFTtUVEZXuD5mqnQ=";
        }
        {
          name = "language-purescript";
          publisher = "nwolverson";
          version = "0.2.8";
          sha256 = "sha256-2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
        }
        {
          name = "ide-purescript";
          publisher = "nwolverson";
          version = "0.26.1";
          sha256 = "sha256-ccTuoDSZKf1WsTRX2TxXeHy4eRuOXsAc7rvNZ2b56MU=";
        }
      ];
    keybindings = [
      {
        key = "alt+j";
        command = "selectNextSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        key = "alt+k";
        command = "selectPrevSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
    ];
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    prezto = {
      enable = true;
      editor.keymap = "vi";
      prompt.theme = "powerlevel10k";
    };
    initExtra = ''
      source "$HOME/.p10k.zsh"
      eval "$(direnv hook zsh)"
    '';
  };

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry.gnome3}/bin/pinentry
    '';
  };

  services.lorri.enable = true;
}
