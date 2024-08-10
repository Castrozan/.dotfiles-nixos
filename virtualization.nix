{ pkgs, ... }:
{
  ###################################################################################
  #
  #  Virtualisation - Libvirt(QEMU/KVM) / Docker / LXD / WayDroid
  #
  ###################################################################################

  # From https://github.com/ryan4yin/nix-config/tree/i3-kickstarter

  # virtualisation.docker.enable = true;
  # users.extraGroups.docker.members = [ "nix" ];
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;

    # start dockerd on boot.
    # This is required for containers which are created with the `--restart=always` flag to work.
    # enableOnBoot = true;
  };

  #virtualisation.docker.enableNvidia = true; # for nvidia-docker
}
