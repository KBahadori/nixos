
{ config, pkgs, lib, inputs, ... }:

{

programs.hyprland = {
  enable = true;
  nvidiaPatches = true;
  xwayland.enable = true;
};

environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSOR = "1"; #if your mouse disappears
  NIXOS_OZONE_WL = "1";
};

# waybar
(pkgs.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  })
)

bind = $mainMod, S, exec, rofi -show drun -show-icons
 
  
}
