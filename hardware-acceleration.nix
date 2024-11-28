{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
    })
  ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      libva-utils
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  environment.etc."mpv/mpv.conf".text = ''
    hwdec=vaapi
    hwdec-codecs=all
    vo=gpu
    gpu-context=wayland
  '';
