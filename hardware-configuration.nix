# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/107a0803-715e-4d3a-87f3-cd730baf32f8";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/0d3e0278-935b-4385-b06b-173cca417000";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8A25-AF4B";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7a863688-aa3d-446c-821a-3cf3d162ad71"; }];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

