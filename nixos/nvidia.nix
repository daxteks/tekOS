# Nvidia configuration for NixOS with Wayland and Hyprland support
# Import this module only if you have an Nvidia GPU
{
  pkgs,
  config,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.production;
in {
  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Improves resume after sleep
  ];

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    NVD_BACKEND = "direct";
  };

  nixpkgs.config.nvidia.acceptLicense = true;

  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      package = nvidiaDriverChannel;
      # forceFullCompositionPipeline = true; # Only useful when display is connected directly to Nvidia GPU, not in PRIME offload mode

    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        egl-wayland
        vulkan-loader
        libva
      ];
    };
  };

  # Nix cache for CUDA
  nix.settings = {
    substituters = ["https://cuda-maintainers.cachix.org"];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
    libva-utils
  ];
}
