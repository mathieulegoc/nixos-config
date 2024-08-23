# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./udev.nix
    ./gnome.nix
    ./virtualization.nix
    ./libs.nix
    inputs.home-manager.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  networking.hostName = "mathieu-work-laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  # services.automatic-timezoned.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-124b";
    #   keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
    packages = with pkgs; [
      terminus_font
    ];
  };

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable fingerprint reader
  # services.fprintd.enable = true;
  # services.fprintd.tod.enable = true;
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

  # services.gnome.core-utilities.enable = false;
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  #  services.blueman.enable = true;

  hardware.graphics = {
    enable = true;
  };

  # sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = true;

    users = {
      root.hashedPassword = "!";
      mathieu = {
        isNormalUser = true;
        home = "/home/mathieu";
        description = "Mathieu";
        extraGroups = ["wheel" "networkmanager" "libvirtd" "docker" "pico"]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
          firefox
          google-chrome
          brave
          tree
          neovim
          stow
          slack
          zed-editor
          lazygit
          zellij
          gcc-arm-embedded
          segger-ozone
          segger-jlink
          picoscope
          vscode
          fzf
          vlc
          cmake
          gcc
          clang
          clang-tools
          gnumake
          gdb
          gimp
          inkscape
          spice
          spice-gtk
          spice-protocol
          win-virtio
          win-spice
          sublime4
          saleae-logic-2
        ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pkgs.waybar
    rofi-wayland
    pkgs.dunst
    libnotify
    alejandra
    swww
    gnomeExtensions.appindicator
    gnome-tweaks
    fuse
    usbutils
    python3
    pyenv
    appimage-run
    openssl
    virtiofsd
  ];

  # picoscope = picoscope.overrideAttrs(finalAttrs: previousAttr: {
  #                               sourceRoot="./picoscope/"+previousAttr.sourceRoot;});
  services.udev.packages = with pkgs; [
    picoscope.rules
    gnome.gnome-settings-daemon
  ];

  programs = {
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland.enable = true;
    dconf.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = ["mathieu"];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        # update = "sudo nixos-rebuild switch --flake ~/nixos-config#work-laptop";
      };
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "robbyrussell";
      };
    };
  };
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "mathieu" = import ./home.nix;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-796s"
    "openssl-1.1.1w"
  ];
  nixpkgs.config.segger-jlink.acceptLicense = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
