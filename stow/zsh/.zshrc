# Shared settings for Arch Linux and macOS.
export EDITOR=nvim
export VISUAL="$EDITOR"

alias vim='nvim'

# Retain command history between sessions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS

# Enable Zsh's built-in completion system.
autoload -Uz compinit
compinit
