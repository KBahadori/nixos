{ config, pkgs, lib, inputs, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
#    ./plasma.nix
    ./hardware-acceleration.nix
  ];

  # Firmware
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # Bootloader (using GRUB)
  boot = {
    loader = {
      systemd-boot.enable = false;
      grub.enable = true;
      grub.device = "nodev";
      grub.useOSProber = false;
      grub.efiSupport = true;
      grub.font = "/boot/grub/fonts/unicode.pf2";
    };
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    # Use latest kernel with NVIDIA
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = [ "nouveau" ];
   # kernelParams = [ "nvidia-drm.modeset=1" ];
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # Additional modprobe config
    extraModprobeConfig = lib.mkDefault ''
      options snd slots=snd_usb_audio,snd-hda-intel
    '';
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Time & Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Keyboard settings
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  # PipeWire (instead of PulseAudio)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Environment variables for NVIDIA/Wayland
  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/implicit_layer.d";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    ELECTRON_ENABLE_WAYLAND = "1";
    ELECTRON_USE_GL = "egl";
    ELECTRON_ENABLE_VAAPI = "1";
    OZONE_PLATFORM = "wayland";
    ELECTRON_FLAGS = "--enable-features=VaapiVideoDecoder --use-gl=egl --enable-hardware-overlays --ozone-platform=wayland";
  };

  # User
  users.users.kb759 = {
    isNormalUser = true;
    description = "kb759";
    extraGroups = [ "networkmanager" "wheel" "audio" "vboxusers" "fuse" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
    ];
    shell = pkgs.fish;
  };

programs.fuse.userAllowOther = true;


  # Hyprland + XWayland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # Cosmic IDE
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.flatpak.enable = true;

  # PolicyKit
  security.polkit.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # SDDM (Wayland)
  services.displayManager.sddm.wayland.enable = true;

  # X server (often needed for Plasma, certain apps, etc.)
  services.xserver.enable = true;

  # Browser, Steam, etc.
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    kitty
    brave
    helix
    #hyprland
    wayland
    wayland-utils
    wl-clipboard
    xwayland     # for X apps on Wayland
    mako         # notification daemon
    fish
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    kdePackages.plasma-workspace
    kdePackages.plasma-wayland-protocols
    jetbrains.pycharm-professional
    vesktop
    vscode
    ranger
    mangohud
    protonup
    mesa
    spotify
    discord
    mesa-demos
    virtualbox
    dconf
    xdg-desktop-portal-hyprland
    wofi
    R
    python3
    waybar
    intel-ocl
    pipewire
    pavucontrol
    sof-firmware
    alsa-ucm-conf
    lshw
    wireplumber
    wpa_supplicant
    networkmanager
    dbus
    rclone
    joplin
    joplin-desktop
    libsForQt5.qtstyleplugin-kvantum
    vulkan-tools
    vulkan-loader
    grim
    swappy
    slurp
    git
    btop
    htop
    libreoffice-qt6-fresh
    sshfs
    yazi
    macchina
  ];

  # Fish shell
  programs.fish.enable = true;

  # VirtualBox groups
  users.groups.vboxusers = {};
  users.extraGroups.vboxusers.members = [ "kb759" ];

  # Enable OpenSSH
  services.openssh.enable = true;

  # NixOS state version
  system.stateVersion = "22.11";

  # Enable Nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
