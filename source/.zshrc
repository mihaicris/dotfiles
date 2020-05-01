#!/usr/bin/env zsh

setopt COMPLETE_ALIASES
setopt AUTOCD
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

autoload -Uz promptinit && promptinit
autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz zmv

NEWLINE=$'\n'
PROMPT='%(?.%F{green}✔.%F{red}?%?)%f %F{yellow}%~%f $(git_super_status)${NEWLINE}%T $ '
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.dotfiles/scripts:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

eval "$(jenv init -)"
eval "$(rbenv init -)"

alias ..=".. && ll"
alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias cart="carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries"
alias cart_update="carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries"
alias def="open https://bp-vsts.visualstudio.com/BPme/_queries/query/6661bd32-ba84-4689-84ba-6850653f115e/"
alias edot="pdot && vim ~/.dotfiles/source/.zshrc"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl='git diff --name-only --diff-filter=U | uniq | xargs $EDITOR'
alias gcm="git add -A && git commit"
alias gcount="git rev-list --count" # argument a branch name
alias gsf="git submodule foreach"
alias gtf="git tag --contains" # argument a commit hash
alias gti="git"
alias ios="cd ~/bpme/uk || return 1"
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias oo="xed ."
alias owa="open https://outlook.office.com/mail/inbox"
alias p="open https://bp-vsts.visualstudio.com/BPme/_apps/hub/ryanstedman.tfs-pullrequest-dashboard.tfs-pullrequest-dashboard"
alias pdot="git -C ~/.dotfiles pull --quiet && rb"
alias rb="source ~/.zshrc"
alias s="git status"
alias work="open https://bp-vsts.visualstudio.com/BPme/_queries/query/a23efe58-988c-49ce-a397-9ef240b1c696/"
alias ytp="youtube-dl --socket-timeout 10 --external-downloader aria2c --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

source "/usr/local/opt/zsh-git-prompt/zshrc.sh"
source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
