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

source "/usr/local/opt/zsh-git-prompt/zshrc.sh"

PROMPT='%(?.%F{green}✔.%F{red}?%?)%f %F{027}%~%f $(git_super_status) $ '
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
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

NORMAL="\033[0m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
#BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
#MAGENTA="\033[35m"
#CYAN="\033[36m"
LIGHT_GRAY="\033[37m"
#DARK_GRAY="\033[90m"
LIGHT_RED="\033[91m"
LIGHT_GREEN="\033[92m"
LIGHT_YELLOW="\033[93m"
LIGHT_BLUE="\033[94m"
#LIGHT_MAGENTA="\033[95m"
#LIGHT_CYAN="\033[96m"
#WHITE="\033[97m"
BG_BLUE="\033[44m"
#BG_LIGHT_BLUE="\033[104m"
#BG_DARK_GRAY="\033[100m"

function pushdir() {
    pushd "$@" > /dev/null || return 1
}

function popdir() {
    popd "$@" > /dev/null || return 1
}

function heading() {
    printf "\n${BOLD}${BG_BLUE}%s${NORMAL}\n\n" "$@"
}

function gr() {
    heading 'Changing to git root folder'
    if git rev-parse --is-inside-git-dir &>/dev/null ; then
        cd "$(git rev-parse --git-dir)" || return
        cd .. || return
        return
    fi
    if git rev-parse &>/dev/null ; then 
        cd "$(git rev-parse --show-toplevel)" || return
    fi
}

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
    echo ""
}

function unstage() {
    heading "Unstaging local changes"
    FILES=$(git diff --name-only --cached | wc -l )
    if (( FILES > 0 )); then
        git diff --name-only --cached 
        printf "\n"
        git reset HEAD --quiet
    else
        printf "* Nothing to unstage.\n"
    fi
}

function discard() {
    heading "Discarding local changes"
    pushdir "$(git rev-parse --show-toplevel)"
    FILES=$(git diff --name-only | wc -l)
    if (( FILES > 0 )); then
        git diff --name-only
        git checkout . --quiet
    else
        printf "* Nothing to discard.\n"
    fi
    popdir
}

function clean_untracked() {
    heading "Cleaning untracked files"
    FILES=$(git clean -fdn | wc -l )
    if (( FILES > 0 )); then
        git clean -fd
    else
        printf "* Nothing to clean.\n"
    fi
}

function gclean() {
    heading "Cleaning ignored files"
    pushdir "$(git rev-parse --show-toplevel)"
    FILES=$(git clean -xdfn -e Carthage/ | wc -l )
    if (( FILES > 0 )); then
        git clean -xdf -e Carthage/
    else
        printf "* Nothing to clean.\n"
    fi
    popdir
}

function recreate_files() {
    heading "Recreating all files"
    pushdir "$(git rev-parse --show-toplevel)"
    git rm --cached -r .
    git reset --hard
    printf "\n"
    popdir
}

function unskipAll() {
    heading "Reactivating skipped files from git"
    FILES=$(git ls-files -v | grep '^S' | cut -d ' ' -f 2 | wc -l)
    if ((  FILES > 0 )); then
        git ls-files -v | grep '^S' | cut -d ' ' -f 2
        echo ""
        git ls-files -v | grep '^S' | cut -d ' ' -f 2 | xargs git update-index --no-skip-worktree
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

function ccb() {
    CRITERIA=$1
    REMOTE_NAME_COUNT=$(git remote | wc -l)
    REMOTE_NAME=$(git remote)
    
    if (( REMOTE_NAME_COUNT != 1 )); then
        printf "Only one remote is supported.\n\n"
        return 1
    fi

    if [[ -z $CRITERIA ]]; then
        RESULTS=(${(@f)$(git branch -r | grep -v "HEAD ->" | sed "s/^[ ]*$REMOTE_NAME\///")})
    else
        RESULTS=(${(@f)$(git branch -r | grep "$CRITERIA" | grep -v "HEAD ->" | sed "s/^[ ]*$REMOTE_NAME\///")})
    fi

    COUNT=$#RESULTS

    if (( COUNT == 0 )); then
        printf "\nThere are no remote branches containing ${LIGHT_RED}%s${NORMAL}.\n\n" "$CRITERIA"
        return 1
    fi

    if (( COUNT > 1 )); then
        printf "\nThere are multiple branches containing ${LIGHT_RED}%s${NORMAL}:\n\n" "$CRITERIA"

        SAVED_PROMPT=$PROMPT3
        PROMPT3="Select a number? "

        printf "%b" "${BLUE}"

        select BRANCH in $RESULTS; do
            if [[ -n "$BRANCH" ]]; then
                LOCAL_BRANCH="$BRANCH"
                break
            else
                printf "%bWrong selection.%b\n" "${RED}" "${BLUE}"
            fi
        done

        printf "%b" "${NORMAL}"
        PROMPT3=$SAVED_PROMPT
    else
        LOCAL_BRANCH=$RESULTS
    fi

    REMOTE_BRANCH="$REMOTE_NAME/$LOCAL_BRANCH"

    IS_ALREADY_LOCAL_BRANCH=$(git branch | grep "$LOCAL_BRANCH")

    if [ -n "$IS_ALREADY_LOCAL_BRANCH" ]; then
        if git checkout -q "$LOCAL_BRANCH" ; then
            printf "\nSuccessfuly switched to the local branch ${LIGHT_GREEN}%s${NORMAL}.\n\n" "$LOCAL_BRANCH"
            return 0
        else
            printf "\nCould not switch to the local branch: ${BLUE}%s${NORMAL}.\n\n" "$LOCAL_BRANCH"
            return 1
        fi
    else
        if git checkout -q -b "$LOCAL_BRANCH" --track "$REMOTE_BRANCH" ; then
            printf "\nSuccessfuly checked out locally the remote branch ${LIGHT_GREEN}%s${NORMAL}.\n\n" "$LOCAL_BRANCH"
            return 0
        else
            printf "\nCould not switch to the remote branch: ${BLUE}%s${NORMAL}.\n\n" "$REMOTE_BRANCH"
            return 1
        fi
    fi
}

function devteam() {
    TEAM=${1:-"S8V3V9GFN2"}
    pushdir "$(git rev-parse --show-toplevel)"
    find . -name "project.pbxproj" \
           -exec sed -i '' -e "s|\(DEVELOPMENT_TEAM = \).*\;|\1${TEAM}\;|g" {} \;
    popdir
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

function pull_branch() {
    BRANCH_REF=$(git symbolic-ref -q HEAD)
    if [ -z $BRANCH_REF ]; then
        printf "%bSkipping (detached state).%b\n" "${LIGHT_RED}" "${NORMAL}"
    else
        CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
        printf "${LIGHT_YELLOW}[%s]${NORMAL}\n" "$CURRENT_BRANCH"
        git fetch --all
        git pull
    fi
}

function ff() {
    TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)
    pushdir $TOP_LEVEL_DIR
    WORKDIRS=(${(@f)$(git worktree list --porcelain  | grep worktree | awk '{print $2}')})
    for WORKDIR in $WORKDIRS; do
        pushdir $WORKDIR || continue
        printf "${UNDERLINE}${GREEN}%b${NORMAL} " "$WORKDIR"
        pull_branch
        printf "\n"
        SUBMODULES=(${(@f)$(git config --file $TOP_LEVEL_DIR/.gitmodules --get-regexp path | awk '{ print $2 }')})
        (( $#SUBMODULES == 0 )) && continue
        for SUBMODULE in $SUBMODULES; do
            printf "${UNDERLINE}${GREEN}%b${NORMAL} " "$SUBMODULE"
            pushdir $SUBMODULE || { printf "Submodule not fetched.\n\n" ; continue }
            pull_branch
            popdir
            printf "\n"
        done
        popdir
    done
    popdir
}

function switch_branch() {
    REPO_PATH=$1
    NEW_BRANCH=$2
    CURRENT_BRANCH=$(git branch --show-current)

    [[ -d $REPO_PATH ]] || { echo "Repo path not valid!"; return 1 ; }
    [[ $NEW_BRANCH ]] || { echo "Branch name is empty"; return 1 ; }
    
    git -C $REPO_PATH fetch --all --quiet
    git -C $REPO_PATH switch --guess --quiet $NEW_BRANCH

    if (( $? == 0 )); then
        printf "Switched to branch: ${GREEN}%s${NORMAL}\n" $NEW_BRANCH
    else
        if [[ $CURRENT_BRANCH ]]; then
            printf "On branch: ${LIGHT_RED}%s${NORMAL}\n" "$CURRENT_BRANCH"
        else
            printf "Repository is in ${LIGHT_RED}DETACHED state${NORMAL}.\n"
        fi
    fi
    printf "\n"
}

function gg() {
    set -x
    BRANCH=${1:-apimaindevelopment}
    TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)
    SUBMODULES=(${(@f)$(git config --file $TOP_LEVEL_DIR/.gitmodules --get-regexp path | awk '{ print $2 }')})
    printf "\n${UNDERLINE}${BOLD}${BLUE}%s${NORMAL}\n" "$(basename "$TOP_LEVEL_DIR")"
    
    switch_branch $TOP_LEVEL_DIR $BRANCH
    for SUBMODULE in $SUBMODULES; do
        printf "${UNDERLINE}${BOLD}${BLUE}%s${NORMAL}\n" "$SUBMODULE"
        switch_branch $TOP_LEVEL_DIR/$SUBMODULE $BRANCH
    done
    set +x
}

#function list_commits() {
#    if [[ -z "$1" ]]; then
#        AUTHOR=$(git config user.name);
#    else
#        if [[ "$1" == "0" ]]; then
#            AUTHOR=".*";
#        else
#            AUTHOR=$1;
#        fi
#    fi
#
#    DAYTODAY=$(date|cut -d ' ' -f 1)
#
#    case $DAYTODAY in
#        "Sat"|"Sun"|"Mon" )
#            SINCE="last.friday.midnight"
#            ;;
#        * )
#            SINCE="yesterday.midnight"
#            ;;
#    esac
#    WIDTH=$(tput cols)
#    if (( WIDTH > 150 )); then
#        WIDTH=$(( WIDTH - 80))
#    else
#        WIDTH="80"
#    fi
#    GIT_DATE_FORMAT='%a, %d %b %H:%M'
#    GIT_PRETTY_FORMAT='%C(bold blue)%<(25,trunc)%an%Creset %<(12,trunc)%Cred%h%Creset %Cgreen%cd  %C(yellow)%<(15)%cr%Creset %<('"${WIDTH}"'i,trunc)%s'
#    GIT_LOG_COMMAND="git --no-pager log
#    --color=always
#    --all
#    --reverse
#    --abbrev-commit
#    --no-merges
#    --oneline
#    --since='$SINCE'
#    --author='$AUTHOR'
#    --date=format:'$GIT_DATE_FORMAT'
#    --pretty=format:'$GIT_PRETTY_FORMAT'"
#    # shellcheck disable=SC2086
#    GIT_OUTPUT=$(eval ${GIT_LOG_COMMAND} 2>/dev/null)
#
#    if [[ -n "$GIT_OUTPUT" ]]; then
#        printf "${LIGHT_GRAY}${UNDERLINE}%s${NORMAL}\n" "$(pwd)"
#        printf "%s\n\n" "$GIT_OUTPUT"
#    fi
#}

#function daily() {
#    heading "Daily Standup"
#    list_commits "$@"
#    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
#    for SUBMODULE in $SUBMODULES; do
#        pushdir "$SUBMODULE"
#        list_commits "$@"
#        popdir 
#    done
#}

function tickets() {
    TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)
    AUTHOR=${1:-$(git config user.name)}
    printf "\n${LIGHT_GREEN}Tickets for: ${LIGHT_BLUE}%s${NORMAL}\n\n" "$AUTHOR"
    REPOS=("." "${(@f)$(git config --file $TOP_LEVEL_DIR/.gitmodules --get-regexp path | awk '{ print $2 }')}")
    {
        for REPO in $REPOS; do
            git -C $REPO log --all --author="$AUTHOR" --format="%s" --no-merges
        done
    } | grep -oE "[A-Za-z]+\/\d+" | grep -oE "[0-9]+" | sort -n -u \
      | xargs -I {} printf "https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%%20Dog/Backlog%%20items/?workitem=${LIGHT_GREEN}{}${NORMAL}\n"
    printf "\n"
}

function oo() {
    xed .
}

function ios() {
    cd ~/bpme/uk || return
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

function gpx() {
    FILE=$(git rev-parse --show-toplevel)/PayAtPump/PayAtPump/CustomLocation.gpx
    skip "$FILE"

    LOCATIONS=()
    NAMES=()
    LATITUDINES=()
    LONGITUDINES=()

    LOCATIONS=(
       'Romania IBM Bucharest;44.4356676;26.0544182'
       'Romania IBM Brasov;45.6687406;25.6194894'
       'Holland Site;51.9386;4.1083'
       'Australia Site;-37.821067;144.966071'
       'US one car wash;41.264578;-96.161076'
    )

    for LOCATION in $LOCATIONS; do
        IFS=";" read -r -A arr <<< "${LOCATION}"
        NAMES=("${NAMES[@]}" "${arr[1]}")
        LATITUDINES=("${LATITUDINES[@]}" "${arr[2]}")
        LONGITUDINES=("${LONGITUDINES[@]}" "${arr[3]}")
    done

    select NAME in $NAMES; do
        if [[ -n $NAME ]]; then
            break
        else
            printf "Wrong selection.\n"
        fi
    done
    
    NAME=${NAMES[$REPLY]}
    LAT=${LATITUDINES[$REPLY]}
    LONG=${LONGITUDINES[$REPLY]}
    
    cat <<EOF > "$FILE"
<?xml version="1.0"?>
<gpx version="1.1" creator="Xcode">
    <wpt lat="$LAT" lon="$LONG"></wpt><!--Custom location: $NAME-->
</gpx>
EOF
}

function search() {
    git log -S"$1"
}

function system_tasks() {
    heading 'Updating gem...'
    sudo gem update --no-document

    heading 'Updating LaTex...'
    sudo tlmgr update --self
    sudo tlmgr update --all

    heading 'Upgrading brew...'
    brew upgrade && brew cask upgrade

    heading 'Updating cocoapods...'
    pod repo update
}

function completions() {
    PREFIX=$(brew --prefix)
    FILES=(
        "share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    )
    for FILE in $FILES; do
        source "$PREFIX/$FILE" || printf "Error: Completion file not found: ${RED}%s${NORMAL}\n" "$FILE" >&2
    done
}

completions
