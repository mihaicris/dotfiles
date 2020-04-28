#!/usr/bin/env zsh

source "/usr/local/opt/zsh-git-prompt/zshrc.sh"

autoload -Uz promptinit compinit
compinit
promptinit

zstyle ':completion:*' menu select

setopt COMPLETE_ALIASES

PROMPT='%{$fg[green]%}%{$reset_color%} %~ $(git_super_status) '