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
autoload -Uz myfunc

NEWLINE=$'\n'
PROMPT='%(?.%F{green}✔.%F{red}?%?)%f %F{yellow}%~%f $(git_super_status)${NEWLINE}%T $ '
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.dotfiles/scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

eval "$(jenv init -)"
eval "$(rbenv init -)"

alias ..=".. && ll"
alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias edot="pdot && vim ~/.dotfiles/source/.zshrc"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl='git diff --name-only --diff-filter=U | uniq | xargs $EDITOR'
alias gcm="git add -A && git commit"
alias gcount="git rev-list --count" # argument a branch name
alias gsf="git submodule foreach"
alias gtf="git tag --contains" # argument a commit hash
alias gti="git"
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias pdot="git -C ~/.dotfiles pull --quiet && rb"
alias rb="source ~/.zshrc"
alias s="git status"
alias ytp="youtube-dl --socket-timeout 10 --external-downloader aria2c --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

function ggfa() {
    prune
    fetch
    status
}

function rr() {
    unstage
    discard
    status
}

function rrr() {
    unskipAll
    unstage
    discard
    status
}

function rrrr() {
    unskipAll
    unstage
    discard
    clean_untracked
    status
}

function rrrrr() {
    unskipAll
    unstage
    discard
    gclean
    status
}

function prune() {
    heading "Pruning branches"
    git remote prune origin
}

function fetch() {
    heading "Fetching remotes"
    git fetch --prune --all --tags
}
#
function status() {
    heading "Status"
    git status
    printf "\n"
}

function unstage() {
    heading "Unstaging local changes"
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    FILES=$(git -C $TOP_LEVEL_DIR diff --name-only --cached | wc -l )
    if (( FILES > 0 )); then
        git -C $TOP_LEVEL_DIR diff --name-only --cached 
        printf "\n"
        git -C $TOP_LEVEL_DIR reset HEAD --quiet
    else
        printf "* Nothing to unstage.\n"
    fi
}

function discard() {
    heading "Discarding local changes"
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    FILES=$(git -C $TOP_LEVEL_DIR diff --name-only | wc -l)
    if (( FILES > 0 )); then
        git -C $TOP_LEVEL_DIR diff --name-only
        git -C $TOP_LEVEL_DIR checkout . --quiet
    else
        printf "* Nothing to discard.\n"
    fi
}

function clean_untracked() {
    heading "Cleaning untracked files"
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    FILES=$(git -C $TOP_LEVEL_DIR clean -fdn | wc -l )
    if (( FILES > 0 )); then
        git -C $TOP_LEVEL_DIR clean -fd
    else
        printf "* Nothing to clean.\n"
    fi
}

function gclean() {
    heading "Cleaning ignored files"
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    FILES=$(git -C $TOP_LEVEL_DIR clean -xdfn -e Carthage/ | wc -l )
    if (( FILES > 0 )); then
        git -C $TOP_LEVEL_DIR clean -xdf -e Carthage/
    else
        printf "* Nothing to clean.\n"
    fi
}

function recreate_files() {
    heading "Recreating all files"
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    git -C $TOP_LEVEL_DIR rm --cached -r .
    git -C $TOP_LEVEL_DIR reset --hard
    printf "\n"
}

function unskipAll() {
    heading "Reactivating skipped files from git"
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    FILES=$(git -C $TOP_LEVEL_DIR ls-files -v | grep '^S' | cut -d ' ' -f 2 | wc -l)
    if (( FILES > 0 )); then
        git -C $TOP_LEVEL_DIR ls-files -v | grep '^S' | cut -d ' ' -f 2
        printf "\n"
        git -C $TOP_LEVEL_DIR ls-files -v | grep '^S' | cut -d ' ' -f 2 | xargs git -C $TOP_LEVEL_DIR update-index --no-skip-worktree
    else 
        printf "* Nothing to reactivate.\n"
    fi
}

function skip() {
    git update-index --skip-worktree "$@"
}

function unskip() {
    git update-index --no-skip-worktree "$@"
}

function hh() {
    heading "Detaching HEAD to previous commit"
    git checkout HEAD~1
    printf "\n"
}

function check() {
    heading "Skipped files"
    git ls-files -v | grep '^S' | cut -d ' ' -f 2
    printf "\n"
}

function transform_reduce() {
    for a in *.mov; do
        ffmpeg -i "$a" -b:v 2048k -vf scale=2048:-1 "${a%.*}.mp4"
    done
}

function transform_ts_to_mp4() {
    for a in *.ts; do
        ffmpeg -i "$a" -c copy "${a%.*}.mp4"
    done
}

function transform_mkv_to_mp4() {
    for a in *.mkv; do
        ffmpeg -i "$a" -c copy "${a%.*}.mp4"
    done
}

function transform_m4a_to_mp3() {
    ffmpeg -i "$1" -acodec libmp3lame -q:a 2 "${1%.*}.mp3"
}

function transform_flac_to_m4a() {
    for a in *.flac; do
        ffmpeg -i "$a" -map 0:0 -acodec alac "${a%.*}.m4a"
    done
}

function oo() {
    xed .
}

function ios() {
    cd ~/bpme/uk || return 1
}

function cart() {
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
    ios_patches
}

function cart_toolchain() {
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain "$1"
}

function cart_update() {
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

function cart_update_toolchain() {
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain "$1"
}

function xcode() {
    sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom11.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

function xcode10() {
    sudo xcode-select -s "/Applications/Xcode10.3.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom10.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

function xcodebeta() {
    sudo xcode-select -s "/Applications/Xcode-beta.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom11.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

function owa() {
    open https://outlook.office.com/mail/inbox
}

function p() {
    open https://bp-vsts.visualstudio.com/BPme/_apps/hub/ryanstedman.tfs-pullrequest-dashboard.tfs-pullrequest-dashboard
}

function vst() {
    [ -z "$1" ] && END="" || END='/?workitem='"$1"
    open https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%20Dog/Backlog%20items"$END"
}

function def() {
    open https://bp-vsts.visualstudio.com/BPme/_queries/query/6661bd32-ba84-4689-84ba-6850653f115e/
}

function work() {
    open https://bp-vsts.visualstudio.com/BPme/_queries/query/a23efe58-988c-49ce-a397-9ef240b1c696/ 
}

function search() {
    git log -S"$1"
}

function completions() {
    PREFIX=$(brew --prefix)
    FILES=(
        "opt/zsh-git-prompt/zshrc.sh"
        "share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    )
    for FILE in $FILES; do
        source "$PREFIX/$FILE" || printf "Error: Completion file not found: ${RED}%s${NORMAL}\n" "$FILE" >&2
    done
}

completions
