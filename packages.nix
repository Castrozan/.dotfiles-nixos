{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run: nix search wget
  environment.systemPackages = with pkgs; [
    # Utils begin
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
    # Utils end

    # Apps begin
    scrcpy
    vscode
    obsidian
    brave
    firefox
    steam
    # Set opera to use its codecs. This enables it to display videos
    (opera.override {
      proprietaryCodecs = true;
    })
    # NordVpn Wireguard client
    # Should install manually rn from github.com/phirecc/wgnord
    wgnord
    # Discord and vesktop to enable screensharing on wayland
    discord
    vesktop
    # Config to enable OpenAsar / Vencord
    (discord.override {
      withOpenASAR = true;
      # Vencord for costumization
      withVencord = true;
    })
    # Apps end
  ];

  # Setting up global Bash configuration
  environment.etc."bashrc".text = ''
    # ~/.bashrc: executed by bash(1) for non-login shells.

    # If not running interactively, don't do anything
    case $- in
        *i*) ;;
          *) return;;
    esac

    # Don't put duplicate lines or lines starting with space in the history.
    HISTCONTROL=ignoreboth

    # Append to the history file, don't overwrite it
    shopt -s histappend

    # Set history length
    HISTSIZE=1000
    HISTFILESIZE=2000

    # Check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # Make less more friendly for non-text input files
    [ -x "$(command -v lesspipe)" ] && eval "$(SHELL=/bin/sh lesspipe)"

    # Set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac

    # Show current git branch in prompt
    parse_git_branch() {
        git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/ (\1)/p'
    }

    if [ "$color_prompt" = yes ]; then
        PS1="\[\e]0\[\033[01;32m\]\u\[\033[00m\]\[\033[01;34m\] \W\[\033[00m\]\[\033[01;1;38;2;253;200;169m\]\$(parse_git_branch)\[\033[00m\]\$ "
    else
        PS1='\u@\h:\w\$(parse_git_branch)\$ '
    fi
    unset color_prompt

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0\u@\h: \W\a\]$PS1"
        ;;
    *)
        ;;
    esac

    # Enable color support of ls and also add handy aliases
    if [ -x "$(command -v dircolors)" ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # Some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias lc='ls -a --color=never'
  '';

  # Optional: Create a global tmux configuration file
  environment.etc."tmux.conf".text = ''
    set-option -sa terminal-overrides ",xterm*:Tc"

    set -g mouse on

    # Start panes and windows at 1
    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-option -g renumber-windows on

    # Set pane name
    set -g @catppuccin_pane_status_enabled "yes"
    set -g @catppuccin_pane_border_status "top"
    set -g @catppuccin_pane_left_separator " "
    set -g @catppuccin_pane_right_separator " "
    set -g @catppuccin_pane_middle_separator " "
    set -g @catppuccin_pane_number_position "left"
    set -g @catppuccin_pane_default_fill "number"
    set -g @catppuccin_pane_default_text "#T"
    set -g @catppuccin_pane_border_style "fg=#{thm_blue}"
    set -g @catppuccin_pane_active_border_style "fg=#{thm_orange}"
    set -g @catppuccin_pane_color "fg=#{thm_blue}"
    set -g @catppuccin_pane_background_color "fg=#{thm_bg}"

    # Set window name
    set -g @catppuccin_window_current_text "#W"
    set -g @catppuccin_window_default_text "#W"

    # Bind ctrl + b, r to rename pane
    bind r command-prompt "select-pane -T '%%'"

    # Open panes in the same directory as the current pane
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"

    # Set plugins after configuration
    run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
    run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
    run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
  '';
}
