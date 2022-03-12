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
export PATH="$HOME/.cargo/bin:$PATH"
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*:*:make:*' tag-order 'targets'
autoload -Uz promptinit && promptinit
autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz zmv

NEWLINE=$'\n'
PROMPT='%(?.%F{green}✔.%F{red}?%?)%f %F{yellow}%~%f $(git_super_status)${NEWLINE}%T $ '
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

eval "$(jenv init -)"
#. /usr/local/opt/asdf/libexec/asdf.sh
grep -slR "PRIVATE" ~/.ssh | xargs ssh-add --apple-use-keychain &> /dev/null

alias ..=".. && ll"
alias bun="bundle exec pod install"
alias cart="carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries"
alias cart_update="carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries"
alias cdot="git -C ~/.dotfiles commit -am 'Updates' ; git -C ~/.dotfiles push"
alias crash='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/crashlytics/app/ios:com.adoreme.qmobile/issues?state=open&time=last-seven-days&type=crash"'
alias connect='open "https://appstoreconnect.apple.com/apps/661053119/appstore/ios/version/deliverable"'
alias remote='open -a "Google Chrome" "https://console.firebase.google.com/u/0/project/adoreme-ios/config"'
alias d='~/cloned/deeplinks/.build/release/deeplinks'
alias edot="pdot && vim ~/.dotfiles/source/.zshrc"
alias fastlane="bundle exec fastlane"
alias ga='open -a "Google Chrome" https://analytics.google.com/analytics/web/#/report-home/a25560459w76793507p79384694'
alias gbf="git branch --contains" # argument a commit hash
alias gcfl='git diff --name-only --diff-filter=U | uniq | xargs $EDITOR'
alias gcm="git add -A && git commit"
alias gcount="git rev-list --count" # argument a branch name
alias gsf="git submodule foreach"
alias gtf="git tag --contains" # argument a commit hash
alias gti="git"
alias gmes="git log --oneline HEAD...develop --format='%s' | cut -d' ' -f2-"
alias ios=". ios"
alias kand="killall studio; killall qemu-system-x86_64"
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias mc="mc --nosubshell"
alias mc-edit="mc-edit --nosubshell"
alias meet='open -a "Google Chrome" https://meet.google.com'
alias meetc='open -a "Google Chrome" https://meet.google.com/eeu-pgga-wsm'
alias mm="fork ."
alias ss="smerge ."
alias oo="xed ."
alias ooa='open -a "Android Studio" ~/adoreme/android'
alias android='cd ~/adoreme/android'
alias p='open https://github.com/adore-me/app-iOS/pulls'
alias pdot="git -C ~/.dotfiles pull && rb"
alias rb="source ~/.zshrc"
alias s="git status"
alias t="tuist edit"
alias tt="tuist generate && bundle exec pod install && open AdoreMe.xcworkspace"
alias ttv="tuist generate --verbose && bundle exec pod install && open AdoreMe.xcworkspace"
alias testflight="open https://appstoreconnect.apple.com/apps/661053119/testflight"
alias wt="git worktree list"
alias ytp="youtube-dl --socket-timeout 20 --external-downloader aria2c --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.1'"
alias xx="killall Xcode"

#GIT_PROMPT_EXECUTABLE="haskell"
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


. /opt/homebrew/opt/asdf/libexec/asdf.sh
