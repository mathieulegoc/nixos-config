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
    # <nixos-hardware/lenovo/thinkpad/x1/9th-gen>
    ./hardware-configuration.nix
    ./udev.nix
    inputs.home-manager.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    cheese
    eog
    gnome-calendar
    cheese # webcam tool
    gnome-terminal
    gnome.gnome-weather
    gnome.gnome-music
    gnome.gnome-contacts
    gnome.gnome-clocks
    gnome.gnome-maps
    gnome-font-viewer
    gnome.gnome-logs
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    totem # video player
    loupe
    simple-scan
    snapshot
    yelp
    gnome-text-editor
    gnome-connections
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "escape:swapcaps";
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    # enable32bit = true;
  };

  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fuse
      udev
      # desktop-file-utils
      # xorg.libXcomposite
      # xorg.libXtst
      # xorg.libXrandr
      # xorg.libXext
      # xorg.libX11
      # xorg.libXfixes
      # libGL
      #
      # gst_all_1.gstreamer
      # gst_all_1.gst-plugins-ugly
      # gst_all_1.gst-plugins-base
      # libdrm
      # xorg.xkeyboardconfig
      # xorg.libpciaccess
      #
      # glib
      # gtk2
      # bzip2
      # zlib
      # gdk-pixbuf
      #
      # xorg.libXinerama
      # xorg.libXdamage
      # xorg.libXcursor
      # xorg.libXrender
      # xorg.libXScrnSaver
      # xorg.libXxf86vm
      # xorg.libXi
      # xorg.libSM
      # xorg.libICE
      # freetype
      # curlWithGnuTls
      # nspr
      # nss
      # fontconfig
      # cairo
      # pango
      # expat
      # dbus
      # cups
      # libcap
      # SDL2
      # libusb1
      # udev
      # dbus-glib
      # atk
      # at-spi2-atk
      # libudev0-shim
      #
      # xorg.libXt
      # xorg.libXmu
      # xorg.libxcb
      # xorg.xcbutil
      # xorg.xcbutilwm
      # xorg.xcbutilimage
      # xorg.xcbutilkeysyms
      # xorg.xcbutilrenderutil
      # libGLU
      # libuuid
      # libogg
      # libvorbis
      # SDL
      # SDL2_image
      # glew110
      # openssl
      # libidn
      # tbb
      # wayland
      # mesa
      # libxkbcommon
      # vulkan-loader
      #
      # flac
      # freeglut
      # libjpeg
      # libpng12
      # libpulseaudio
      # libsamplerate
      # libmikmod
      # libtheora
      # libtiff
      # pixman
      # speex
      # SDL_image
      # SDL_ttf
      # SDL_mixer
      # SDL2_ttf
      # SDL2_mixer
      # libappindicator-gtk2
      # libcaca
      # libcanberra
      # libgcrypt
      # libvpx
      # librsvg
      # xorg.libXft
      # libvdpau
      # alsa-lib
      #
      # harfbuzz
      # e2fsprogs
      # libgpg-error
      # keyutils.lib
      # libjack2
      # fribidi
      # p11-kit
      #
      # gmp
      #
      # libtool.lib
      # xorg.libxshmfence
      # at-spi2-core
      # gtk3
      # stdenv.cc.cc.lib
    ];
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      root.hashedPassword = "!";
      mathieu = {
        isNormalUser = true;
        home = "/home/mathieu";
        description = "Mathieu";
        extraGroups = ["wheel" "networkmanager" "libvirtd"]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
          firefox
          google-chrome
          tree
          neovim
          stow
          slack
          alacritty
          zed-editor
          lazygit
          zellij
          gcc-arm-embedded
          segger-ozone
          segger-jlink
          picoscope
          vscode
        ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
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
  ];

  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  programs.hyprland.enable = true;
  programs.dconf.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = ["mathieu"];
  };

  programs.zsh = {
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
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "mathieu" = import ./home.nix;
    };
  };
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-796b"
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
