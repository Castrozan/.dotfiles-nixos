{ pkgs, ... }:
{
  # Global Bash configuration
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
}
