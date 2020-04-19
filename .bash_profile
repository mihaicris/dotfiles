#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="/usr/local/opt/gettext/bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

eval "$(jenv init -)"
eval "$(rbenv init -)"

alias ..="cd .. && ll"
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"

alias rb="source ~/.bash_profile"
alias pdot="pushdir ~/.dotfiles && git pull --quiet && popdir && rb"
alias edot="pdot && vim ~/.dotfiles/.bash_profile"
alias ytp="youtube-dl --socket-timeout 10 --external-downloader aria2c --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl='git diff --name-only --diff-filter=U | uniq | xargs $EDITOR'
alias gcount="git rev-list --count" # argument a branch name
alias gtf="git tag --contains" # argument a commit hash
alias gcm="git add -A && git commit"
alias gsf="git submodule foreach"
alias s="git status"
alias gti="git"

RED=$(tput setaf 1); export RED
GREEN=$(tput setaf 2); export GREEN
YELLOW=$(tput setaf 3); export YELLOW
#BLUE=$(tput setaf 4); export BLUE
#BOLD=$(tput bold); export BOLD
UNDERLINE=$(tput smul); export UNDERLINE
NORMAL=$(tput sgr0); export NORMAL

function pushdir() {
    command pushd "$@" > /dev/null || printf "%b" "Error, could not popd to previous folder\n" >&2
}

# shellcheck disable=SC2120
function popdir() {
    command popd "$@" > /dev/null || printf "%b" "Error, could not popd to previous folder\n" >&2
}

function heading() {
    echo -e "\n\033[7m\033[034m" "$@" "\033[0m\n"
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

function sedi() {
    if sed --version >/dev/null 2>&1 ; then 
        sed -b -i -- "$@"
    else
        sed -i "" "$@"
    fi
}

function ccb() {
    local CRITERIA=$1

    if (( $# != 1 )); then
        printf "\033[92m\nPlease specifiy one argument as branch to checkout locally from remote.\033[0m\n\n"
        return 1
    fi

    REMOTE_NAME_COUNT=$(git remote | wc -l)

    if (( REMOTE_NAME_COUNT != 1 )); then
        printf "Only one remote is supported.\n\n"
        return 1
    fi

    REMOTE_NAME=$(git remote)
    SEARCH_RESULTS=$(git branch -r | grep "$CRITERIA" | grep -v "HEAD ->" | sed "s/^[ ]*$REMOTE_NAME\///")
    COUNT=$(git branch -r | grep "$CRITERIA" | grep -c -v "HEAD ->")

    if (( COUNT == 0 )); then
        printf "\nThere are no remote branches containing \033[91m%s\033[0m.\n\n" "$CRITERIA"
        return 1
    fi

    if (( COUNT > 1 )); then
        printf "\nThere are multiple branches containing \033[91m%s\033[0m:\n\n\033[34m" "$CRITERIA"

        PROMPT=$PS3
        PS3="Select a number? "
        select BRANCH in $SEARCH_RESULTS; do
            IS_SELECTION_VALID=$([[ -n $BRANCH ]] && echo -e "$SEARCH_RESULTS" | grep "$BRANCH")
            if [[ $IS_SELECTION_VALID ]]; then
                LOCAL_BRANCH="$BRANCH"
                break
            else
                printf "Wrong selection.\n"
            fi
        done

        printf "\033[0m"
        PS3=$PROMPT
    else
        LOCAL_BRANCH=$SEARCH_RESULTS
    fi

    REMOTE_BRANCH="$REMOTE_NAME/$LOCAL_BRANCH"

    IS_ALREADY_LOCAL_BRANCH=$(git branch | grep "$LOCAL_BRANCH")
    if [ -n "$IS_ALREADY_LOCAL_BRANCH" ]; then
        if git checkout -q "$LOCAL_BRANCH" ; then
            printf "\nSuccessfuly switched to the local branch \033[92m%s\033[0m.\n\n" "$LOCAL_BRANCH"
            return 0
        else
            prinf "\nCould not switch to the local branch: \033[34m%s\033[0m.\n\n" "$LOCAL_BRANCH"
            return 1
        fi
    else
        if git checkout -q -b "$LOCAL_BRANCH" --track "$REMOTE_BRANCH" ; then
            printf "\nSuccessfuly checked out locally the remote branch \033[92m%s\033[0m.\n\n" "$LOCAL_BRANCH"
            return 0
        fi
    fi
}

function devteam() {
    TEAM=${1:-"S8V3V9GFN2"}
    pushdir "$(git rev-parse --show-toplevel)"
    FILES=$(find . -name "project.pbxproj")
    for FILE in $FILES; do
        sedi "s/\(DEVELOPMENT_TEAM = \).*\;/\1$TEAM\;/g" "$FILE"
    done
    popdir
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

function ff() {
    ggfa
    heading "Fast forwarding all worktrees"
    WORKDIRS=$(git worktree list --porcelain  | grep worktree | awk '{print $2}')
    for WORKDIR in $WORKDIRS
    do
        printf "\033[92m* Fast forwarding \033[94m%s " "$WORKDIR"
        pushdir "$WORKDIR"
        IS_DETACHED=$(git symbolic-ref -q HEAD)
        if [[ -z $IS_DETACHED ]]; then
            printf "\n\033[91mSkipping (detached state).\033[0m\n\n"
        else
            CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
            printf "\033[93m[%s]\033[0m\n" "$CURRENT_BRANCH"
            git pull
            echo ""
        fi
        popdir
    done
}

function refresh() {
    printf "%s\n" "${NORMAL}"
    git fetch --all -p
    CURRENT_BRANCH=$(git branch --show-current)
    HAS_BRANCH=$(git branch | grep "$1")

    if [[ -n $HAS_BRANCH ]] && [[ $CURRENT_BRANCH != "$1" ]]; then
        git switch --quiet "$1"
        printf "Changed branch to: ${RED}%s${NORMAL}\n" "$1"
    else
        printf "On branch: ${YELLOW}%s${NORMAL}\n" "$CURRENT_BRANCH"
    fi
    git pull
    printf "%s\n" "${GREEN}"
}

export -f refresh

function gg() {
    BRANCH=${1:-apimaindevelopment}
    TOP_LEVEL_DIR=$(basename "$(git rev-parse --show-toplevel)")
    
    printf "%s\n" "${GREEN}"
    printf "Entering ${BLUE}%s\n" "$TOP_LEVEL_DIR"

    refresh "$BRANCH"

    printf "%s" "${GREEN}"
    git submodule foreach bash -c "refresh $BRANCH"
}

function list-commits() {
    if [ -z "$1" ]; then
        author=$(git config user.name);
    else
        if [[ "$1" == "0" ]]; then
            author=".*";
        else
            author=$1;
        fi
    fi
    
    daytoday=$(date|cut -d ' ' -f 1)
    case $daytoday in
    "Sat"|"Sun"|"Mon" )
        since="last.friday.midnight"
        ;;
    * )
        since="yesterday.midnight"
        ;;
    esac

    GIT_DATE_FORMAT='%a, %d %b %H:%M'
    GIT_PRETTY_FORMAT='%C(bold blue)%<(25,trunc)%an%Creset %<(12,trunc)%Cred%h%Creset %Cgreen%cd  %C(yellow)%<(15)%cr%Creset %<(60,trunc)%s'
    GIT_LOG_COMMAND="git --no-pager log
        --color=always
        --all
        --reverse
        --abbrev-commit
        --no-merges
        --oneline
        --since='$since'
        --author='$author'
        --date=format:'$GIT_DATE_FORMAT'
        --pretty=format:'$GIT_PRETTY_FORMAT'"
    # shellcheck disable=SC2086
    GIT_OUTPUT=$(eval ${GIT_LOG_COMMAND} 2>/dev/null)
    
    if [[ -n "$GIT_OUTPUT" ]]; then
        printf "\033[37m\033[4m%s\033[0m\n" "$(basename "$(pwd)")"
        printf "%s\n\n" "$GIT_OUTPUT"
    fi
}

function ios() {
    cd ~/bpme/main || return
}

function daily() {
    heading "Daily Standup"
    list-commits "$@"
    submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    for submodule in $submodules
    do
        pushdir "$submodule"
        list-commits "$@"
        popdir 
    done
}

function tickets() {
    if [ -z "$1" ]; then
        AUTHOR=$(git config user.name);
        NAME=$AUTHOR
    else
        AUTHOR=$1
        if [ "$1" == "0" ]; then
            NAME="All authors"
        else
            NAME=$1
        fi
    fi
    printf "\n\033[92mTickets for: \033[94m%s\033[0m\n\n" "$NAME"
    daily "$AUTHOR" | \
        grep -oE "/[0-9]{5,}" | \
        grep -oE "[0-9]+" | \
        sort | \
        uniq | \
        xargs -I {} printf "https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%%20Dog/Backlog%%20items/?workitem=\033[92m{}\033[0m\n"
    printf "\n"
}

function allIssues() {
    AUTHOR=${1:-$(git config user.name)}
    (git log --author="$AUTHOR" --format="%s" --no-merges && \
     git submodule foreach git log --author="$AUTHOR" --format="%s" --no-merges) \
   | grep -oE "[A-Za-z]+\/\d+" | sort -u
}

function oo() {
    xed .
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
    if [ -z "$1" ]; then
        open https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%20Dog/Backlog%20items
    else
        open https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%20Dog/Backlog%20items/?workitem="$1"
    fi
}

function def() {
    open https://bp-vsts.visualstudio.com/BPme/_queries/query/6661bd32-ba84-4689-84ba-6850653f115e/
}

function work() {
    open https://bp-vsts.visualstudio.com/BPme/_queries/query/a23efe58-988c-49ce-a397-9ef240b1c696/ 
}

function gpx() {
    file_location=$(git rev-parse --show-toplevel)/PayAtPump/PayAtPump/CustomLocation.gpx
    cat <<\EOF > "$file_location"
<?xml version="1.0"?>
<gpx version="1.1" creator="Xcode">
    <wpt lat="44.4356676" lon="26.0544182"></wpt>
</gpx>
EOF
skip "$file_location"
}

function gpxAUS() {
    file_location=$(git rev-parse --show-toplevel)/PayAtPump/PayAtPump/CustomLocation.gpx
    cat <<\EOF > "$file_location"
<?xml version="1.0"?>
<gpx version="1.1" creator="Xcode">
    <wpt lat="-37.821067" lon="144.966071"></wpt>
</gpx>
EOF
    skip "$file_location"
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

    heading 'Updating brew cask...'
    brew cask upgrade

    heading 'Updating cocoapods...'
    pod repo update
}

function addBashCompletion() {
    # shellcheck disable=SC1090
    source "$1" || printf "Error: Completion file not found: %si\n" "$1" >&2
}

addBashCompletion "$(brew --prefix)/etc/bash_completion"
addBashCompletion "$(brew --prefix)/etc/bash_completion.d/brew"
addBashCompletion "$(brew --prefix)/etc/bash_completion.d/tmux"
addBashCompletion "$(brew --prefix)/etc/bash_completion.d/carthage"
addBashCompletion "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
addBashCompletion "$(brew --prefix)/etc/bash_completion.d/launchctl"
addBashCompletion "$(brew --prefix)/etc/bash_completion.d/tig-completion.bash"
addBashCompletion "$(brew --prefix)/etc/bash_completion.d/youtube-dl.bash-completion"
addBashCompletion "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"

