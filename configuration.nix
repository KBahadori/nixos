# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./plasma.nix
      #./hardware-acceleration.nix
      #./modules/omen_14.nix
      #./gnome.nix 

    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true; 
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # filesystems
#  services.xserver.enable = true;
#  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.desktopManager.gnome.enable = true;

  # additional boot params for wayland
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  boot.initrd.kernelModules = 
  [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";
 
  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
   # Vulkan support
  environment.variables = {
  VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
  VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/implicit_layer.d";
  LIBVA_DRIVER_NAME = "nvidia";
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Define GPU and electron use
  environment.variables = {
  ELECTRON_ENABLE_WAYLAND = "1";   # Enables Wayland for Electron apps
  ELECTRON_USE_GL = "egl";        # Forces EGL for rendering
  ELECTRON_ENABLE_VAAPI = "1";    # Enables VA-API for video acceleration
  OZONE_PLATFORM = "wayland";     # Specifies Wayland platform
  #CUDA_VISIBLE_DEVICES = "1";     # Prioritize the RTX 3080 (GPU index)
 # NIXOS_OZONE_WL = "1"; 
  };
  environment.variables.ELECTRON_FLAGS = "--enable-features=VaapiVideoDecoder --use-gl=egl --enable-hardware-overlays --ozone-platform=wayland";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kb759 = {
    isNormalUser = true;
    description = "kb759";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
    ];
    shell = pkgs.fish;
  };
  
  # hyprland config
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  services.displayManager.sddm.wayland.enable = true;
  

  # Install firefox.
  programs.firefox.enable = true;
  services.xserver.enable = true;
 # services.xserver.displayManager.enable = true;
 # services.xserver.desktopManager.gnome.enable = true;
  
  # Steam
  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
    gamescopeSession.enable = false;
    };
  
  programs.gamemode.enable = true; 
#  xdg.portal.enable = true;
#  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   kitty
   brave
   helix 
   hyprland
   wayland
   wayland-utils
   wl-clipboard
   xwayland  # Required for compatibility with X11 apps
   kitty     # Optional: Wayland-compatible terminal emulator
   mako      # Optional: Notification daemon
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
   ];

    programs.fish = {
      enable = true;
       };
    
 
  # Version
  system.stateVersion = "24.11";
 # nixpkgs.config.allowUnfree = pkgs.lib.mkForce = true;
 # services.xserver.videoDrivers = lib.mkDefault ["nvidia"];
 # environment.sessionVariables = {
  #  STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/root/compatibilitytools.d";
   # };  
  
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "kb759"];
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html  system.stateVersion = "24.05"; # Did you read the comment?

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"]; 
}
