{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      trusted-users = [
        "root"
        "nick"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "sphx01w08";
  networking.wireless = {
    enable = true;
    networks = import ./networks.secret.nix;
  };
  networking.networkmanager.enable = false;

  time.timeZone = "America/Phoenix";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
  ];

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/78535
  # hardware.printers = {
  #   ensureDefaultPrinter = "sphx01p01";
  #   ensurePrinters = [
  #     {
  #       name = "sphx01p01";
  #       deviceUri = "ipp://sphx01p01.home/binary_p1";
  #       model = "Generic PCL Laser Printer";
  #       location = "Office";
  #       description = "Brother HL-2070N";
  #     }
  #   ];
  # };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.nick = {
    description = "Nick Saunders";
    isNormalUser = true;
    initialPassword = "nick";
    extraGroups = ["networkmanager" "wheel"];
  };

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  services.syncthing = {
    enable = true;
    user = "nick";
    dataDir = "/home/nick/Documents";
    configDir = "/home/nick/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    devices = {
      "sphx01m01" = {id = "PKRTMPE-RQGGBPB-37NEN2Z-Q462UEV-RZQBJJN-SJ4DNE2-3DHSW73-KWM4YQE";};
    };
    folders = {
      "Documents" = {
        path = "/home/nick/Documents";
        devices = ["sphx01m01"];
      };
    };
  };
}
