{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./tmux.nix
  ];

  # List packages installed in system profile. To search, run: nix search wget
  environment.systemPackages = with pkgs; [
    # UTILS BEGIN
    vim
    git
    bash-completion
    tmux
    wget
    fzf
    jq
    wireguard-go
    direnv
    nixpkgs-fmt
    linuxKernel.packages.linux_5_4.wireguard
    wireguard-tools
    ffmpeg
    gh
    # UTILS END

    # APPS BEGIN
    scrcpy
    vscode
    obsidian
    brave
    firefox
    steam
    # Set opera to use its codecs. This enables it to display videos
    (
      opera.override {
        proprietaryCodecs = true;
      }
    )
    # NordVpn Wireguard client
    # Should install manually rn from github.com/phirecc/wgnord
    wgnord
    # Discord and vesktop to enable screensharing on wayland
    discord
    vesktop
    # Config to enable OpenAsar / Vencord
    (
      discord.override {
        withOpenASAR = true;
        # Vencord for costumization
        withVencord = true;
      }
    )
    # APPS END
  ];
}
