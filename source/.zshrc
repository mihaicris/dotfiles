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

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.dotfiles/scripts:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
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

eval "$(jenv init -)"
eval "$(rbenv init -)"
# eval "$(pyenv init -)"

alias ..=".. && ll"
alias bun="bundle exec pod install"
alias cart="carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries"
alias cart_update="carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries"
alias cdot="git -C ~/.dotfiles commit -am 'Updates' && git -C ~/.dotfiles push"
alias crash='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/crashlytics/app/ios:com.adoreme.qmobile/issues?state=open&time=last-seven-days&type=crash"'
alias edot="pdot && vim ~/.dotfiles"
alias fastlane="bundle exec fastlane"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl='git diff --name-only --diff-filter=U | uniq | xargs $EDITOR'
alias gcm="git add -A && git commit"
alias gcount="git rev-list --count" # argument a branch name
alias gsf="git submodule foreach"
alias gtf="git tag --contains" # argument a commit hash
alias gti="git"
alias ios=". ios"
alias kand="killall studio; killall qemu-system-x86_64"
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias meet='open -a "Google Chrome" https://meet.google.com'
alias mm="fork ."
alias oo="xed ."
alias p='open https://github.com/adore-me/app-iOS/pulls'
alias pdot="git -C ~/.dotfiles pull && rb"
alias rb="source ~/.zshrc"
alias s="git status"
alias t="tuist edit"
alias tt="tuist generate --open"
alias wt="git worktree list"
alias ytp="youtube-dl --socket-timeout 10 --external-downloader aria2c --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.1'"

source "/usr/local/opt/zsh-git-prompt/zshrc.sh"
GIT_PROMPT_EXECUTABLE="haskell"
source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


