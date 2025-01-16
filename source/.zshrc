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
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.dotfiles/scripts:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/Users/mihai.c/.cargo/bin:$PATH"
zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*:*:make:*' tag-order 'targets'

fpath=(~/.zsh/completion $fpath)
autoload -Uz promptinit && promptinit
autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz zmv

NEWLINE=$'\n'
PROMPT='%(?.%F{green}✔.%F{red}?%?)%f %F{yellow}%~%f $(git_super_status)${NEWLINE}%T $ '
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
MAILCHECK=0
grep -slR "PRIVATE" ~/.ssh | xargs ssh-add --apple-use-keychain &> /dev/null

GIT_PROMPT_EXECUTABLE="python"
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
eval "$(/opt/homebrew/bin/mise activate zsh)"
export PATH=$HOME/flutter/bin:$PATH
alias ..=".. && ll"
alias ab='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/experiments/list"'
alias aaa='open -a Safari "https://github.com/adore-me/app-iOS/actions"'
alias am="~/.dotfiles/tools/am/.build/arm64-apple-macosx/release/am"
alias android='cd ~/android-app'
alias cdot="git -C ~/.dotfiles commit -am 'Updates' ; git -C ~/.dotfiles push"
alias confluence='open "https://adoreme.atlassian.net/wiki/spaces/AMA/overview"'
alias connect='open "https://appstoreconnect.apple.com"'
alias cram='open -a "Google Chrome" "https://cramberry.adoreme.com"'
alias crash='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/crashlytics/app/ios:com.adoreme.qmobile/issues?state=open&time=last-ninety-days&type=crash"'
alias nonfatals='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/crashlytics/app/ios:com.adoreme.qmobile/issues?state=open&time=last-ninety-days&tag=all&sort=eventCount"'
alias deeplink='~/.dotfiles/tools/deeplinks/.build/release/deeplinks'
alias edot="pdot && vim ~/.dotfiles/source/.zshrc"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl='git diff --name-only --diff-filter=U | uniq | xargs $EDITOR'
alias gcount="git rev-list --count" # argument a branch name
alias gmes="git log --oneline HEAD...develop --format='%s' | cut -d' ' -f2-"
alias gsf="git submodule foreach"
alias gtf="git tag --contains" # argument a commit hash
alias gti="git"
alias ios=". ios"
alias kand="killall studio; killall qemu-system-x86_64"
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias mc-edit="mc-edit --nosubshell"
alias mc="mc --nosubshell"
alias meet='open -a "Google Chrome" https://meet.google.com'
alias meetc='open -a "Google Chrome" https://meet.google.com/eeu-pgga-wsm'
alias mm="fork ."
alias mt="fork log -- "
alias oo="xed ."
alias ooa='cd ~/android-app && open -a "Android Studio" ~/android-app'
alias p='open https://github.com/adore-me/app-iOS/pulls'
alias pdot="git -C ~/.dotfiles pull && rb"
alias python="python3"
alias rb="source ~/.zshrc"
alias remote='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/config"'
alias s="git status"
alias t="tuist edit"
alias testflight="open https://appstoreconnect.apple.com/apps/661053119/testflight"
alias vim="nvim"
alias vv="nvim ."
alias ytp1="yt-dlp --playlist-reverse --socket-timeout 20 -f worst --external-downloader aria2c"
alias ytp2="yt-dlp --socket-timeout 20 -f worst --external-downloader aria2c"
alias ytp="yt-dlp -f best --external-downloader aria2c"
alias tg="tuist graph"
alias chirie="open 'https://docs.google.com/spreadsheets/d/1Kwa-8Z5SJUAEyrtdOHES0Z436ys0ujOskxHh_RwfwbU/edit?gid=341339929#gid=341339929'"
alias xx="killAll Xcode Fork"

