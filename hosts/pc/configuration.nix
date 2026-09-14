{config, pkgs, ...}: {
  imports = [
    ../../nixos/nvidia.nix
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/tuigreet.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../home/programs/gui/helium/system.nix
    ./hardware-configuration.nix
    ./variables.nix
  ];

  services.desktopManager.plasma6.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "26.05";
}
