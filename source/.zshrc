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


alias ..=".. && ll"
alias ab='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/experiments/list"'
alias actions='open "https://github.com/adore-me/app-iOS/actions"'
alias am="~/.dotfiles/tools/am/.build/arm64-apple-macosx/release/am"
alias android='cd ~/android-app'
alias cdot="git -C ~/.dotfiles commit -am 'Updates' ; git -C ~/.dotfiles push"
alias confluence='open "https://adoreme.atlassian.net/wiki/spaces/AMA/pages/174555212/For+You+as+Homepage"'
alias connect='open "https://appstoreconnect.apple.com"'
alias cram='open -a "Google Chrome" "https://cramberry.adoreme.com"'
alias crash='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/crashlytics/app/ios:com.adoreme.qmobile/issues?state=open&time=last-seven-days&type=crash"'
alias deeplink='~/.dotfiles/tools/deeplinks/.build/release/deeplinks'
alias edot="pdot && vim ~/.dotfiles/source/.zshrc"
alias ga4='open -a "Google Chrome" https://analytics.google.com/analytics/web/#/p152238647'
alias ga4s='open -a "Google Chrome" https://analytics.google.com/analytics/web/#/p167739832'
alias ga='open -a "Google Chrome" https://analytics.google.com/analytics/web/#/report-home/a25560459w76793507p79384694'
alias gbf="git branch --contains" # argument a commit hash
alias gcfl='git diff --name-only --diff-filter=U | uniq | xargs $EDITOR'
alias gcount="git rev-list --count" # argument a branch name
alias gmes="git log --oneline HEAD...develop --format='%s' | cut -d' ' -f2-"
alias gsf="git submodule foreach"
alias gtf="git tag --contains" # argument a commit hash
alias gti="git"
alias gtm='open -a "Google Chrome" "https://tagmanager.google.com/#/container/accounts/131805499/containers/6116323/workspaces/126?orgId=wO26D2aFTgy1rvfFYjn9Sw"'
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
alias tca="~/adoreme/TCA/ios-app-tca && make"
alias testflight="open https://appstoreconnect.apple.com/apps/661053119/testflight"
alias vim="nvim"
alias vv="vim ."
alias ytp1="yt-dlp --playlist-reverse --socket-timeout 20 -f worst --external-downloader aria2c"
alias ytp2="yt-dlp --socket-timeout 20 -f worst --external-downloader aria2c"
alias ytp="yt-dlp -f best --external-downloader aria2c"
alias tg="tuist graph"
alias chirie="open 'https://docs.google.com/spreadsheets/d/1Kwa-8Z5SJUAEyrtdOHES0Z436ys0ujOskxHh_RwfwbU/edit?gid=341339929#gid=341339929'"

function gcm() {
    git add .
    if [ -n "$1" ]
    then
      str="$1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11"
      trimmed="${str## }"  # Remove leading spaces
      trimmed="${trimmed%% }"  # Remove trailing spaces
      git commit -m "$trimmed"  
    else
      git commit -m Updates
    fi
}

function ca() {
    open "https://order.adoreme.com/customers/$1"
}

GIT_PROMPT_EXECUTABLE="python"
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
eval "$(/opt/homebrew/bin/mise activate zsh)"
export PATH=$HOME/flutter/bin:$PATH
