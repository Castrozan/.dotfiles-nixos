{ pkgs, ... }:
{
  # Docker configuration
  virtualisation.docker = {
    enable = true;
    #setSocketVariable = true;
    #enableNvidia = true; # for nvidia-docker

    # start dockerd on boot.
    # This is required for containers which are created with the `--restart=always` flag to work.
    enableOnBoot = true;
  };
  users.extraGroups.docker.members = [ "nix" ];
}
