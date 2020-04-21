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

RED_COLOR=$(tput setaf 1)
GREEN_COLOR=$(tput setaf 2)
YELLOW_COLOR=$(tput setaf 3)
BLUE_COLOR=$(tput setaf 4)
BOLD_FONT=$(tput bold)
UNDERLINE_FONT=$(tput smul)
NORMAL_FONT=$(tput sgr0)

function pushdir() {
    command pushd "$@" > /dev/null || printf "%b" "Error, could not popd to previous folder\n" >&2
}

# shellcheck disable=SC2120
function popdir() {
    command popd "$@" > /dev/null || printf "%b" "Error, could not popd to previous folder\n" >&2
}

function heading() {
    printf "\n\033[7m\033[034m%s\033[0m\n\n" "$@"
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
    CRITERIA=$1
    REMOTE_NAME_COUNT=$(git remote | wc -l)
    REMOTE_NAME=$(git remote)

    if (( $# != 1 )); then
        printf "\033[92m\nPlease specifiy one argument as branch to checkout locally from remote.\033[0m\n\n"
        return 1
    fi

    if (( REMOTE_NAME_COUNT != 1 )); then
        printf "Only one remote is supported.\n\n"
        return 1
    fi

    RESULTS=$(git branch -r | grep "$CRITERIA" | grep -v "HEAD ->" | sed "s/^[ ]*$REMOTE_NAME\///")
    COUNT=$(echo "${RESULTS}" | wc -l)

    if (( COUNT == 0 )); then
        printf "\nThere are no remote branches containing \033[91m%s\033[0m.\n\n" "$CRITERIA"
        return 1
    fi

    if (( COUNT > 1 )); then
        printf "\nThere are multiple branches containing \033[91m%s\033[0m:\n\n\033[34m" "$CRITERIA"

        PROMPT=$PS3
        PS3="Select a number? "
        select BRANCH in $RESULTS; do
            IS_SELECTION_VALID=$([[ -n $BRANCH ]] && echo -e "$RESULTS" | grep "$BRANCH")
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
        LOCAL_BRANCH=$RESULTS
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

function pull_branch() {
    IS_DETACHED=$(git symbolic-ref -q HEAD)

    if [[ -z $IS_DETACHED ]]; then
        printf "\033[91mSkipping (detached state).\033[0m\n"
    else
        CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
        printf "\033[93m[%s]\033[0m\n" "$CURRENT_BRANCH"
        git fetch --all --quiet
        git pull
    fi
}

function ff_submodules() {
    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    [[ -z $SUBMODULES ]] && return 0
    heading "Fast forwarding all submodules"
    for SUBMODULE in $SUBMODULES; do
        printf "${UNDERLINE_FONT}${GREEN_COLOR}%b${NORMAL_FONT} " "$SUBMODULE"
        pushdir "$SUBMODULE"
        pull_branch        
        popdir
        printf "%b" "\n"
    done
}

function ff_worktrees() {
    WORKDIRS=$(git worktree list --porcelain  | grep worktree | awk '{print $2}')
    heading "Fast forwarding all worktrees"
    for WORKDIR in $WORKDIRS; do
        printf "${UNDERLINE_FONT}${GREEN_COLOR}%b${NORMAL_FONT} " "$(basename "$WORKDIR")"
        pushdir "$WORKDIR"
        pull_branch
        popdir
        printf "%b" "\n"
    done
}

function ff() {
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    pushdir "$TOP_LEVEL_DIR"
    ff_submodules
    ff_worktrees
    popdir
}

function refresh() {
    git fetch --all -p
    CURRENT_BRANCH=$(git branch --show-current)
    HAS_BRANCH=$(git branch | grep "$1")

    if [[ -n $HAS_BRANCH ]] && [[ $CURRENT_BRANCH != "$1" ]]; then
        git switch --quiet "$1"
        printf "Changed branch to: ${RED_COLOR}%s${NORMAL_FONT}\n" "$1"
        git pull
    else
        printf "On branch: ${YELLOW_COLOR}%s${NORMAL}\n" "$CURRENT_BRANCH"
    fi
    printf "\n"
}

function gg() {
    BRANCH=${1:-apimaindevelopment}
    TOP_LEVEL_DIR="$(git rev-parse --show-toplevel)"
    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')

    printf "\n${UNDERLINE_FONT}${BOLD_FONT}${BLUE_COLOR}%s${NORMAL_FONT}\n" "$(basename "$TOP_LEVEL_DIR")"
    pushdir "$TOP_LEVEL_DIR"
    refresh "$BRANCH"

    for SUBMODULE in $SUBMODULES; do
        printf "${UNDERLINE_FONT}${BOLD_FONT}${BLUE_COLOR}%s${NORMAL_FONT}\n" "$SUBMODULE"
        pushdir "$SUBMODULE"
        refresh "$BRANCH"
        popdir 
    done
    popdir
}

function list_commits() {
    if [[ -z "$1" ]]; then
        AUTHOR=$(git config user.name);
    else
        if [[ "$1" == "0" ]]; then
            AUTHOR=".*";
        else
            AUTHOR=$1;
        fi
    fi

    DAYTODAY=$(date|cut -d ' ' -f 1)

    case $DAYTODAY in
        "Sat"|"Sun"|"Mon" )
            SINCE="last.friday.midnight"
            ;;
        * )
            SINCE="yesterday.midnight"
            ;;
    esac
    WIDTH=$(stty -a | grep columns | cut -d';' -f3 | grep -oE '\d+')
    if [[ -n $WIDTH ]] && (( WIDTH > 150 )); then
        WIDTH=$(( WIDTH - 80))
    else
        WIDTH="80"
    fi
    GIT_DATE_FORMAT='%a, %d %b %H:%M'
    GIT_PRETTY_FORMAT='%C(bold blue)%<(25,trunc)%an%Creset %<(12,trunc)%Cred%h%Creset %Cgreen%cd  %C(yellow)%<(15)%cr%Creset %<('"${WIDTH}"'i,trunc)%s'
    GIT_LOG_COMMAND="git --no-pager log
    --color=always
    --all
    --reverse
    --abbrev-commit
    --no-merges
    --oneline
    --since='$SINCE'
    --author='$AUTHOR'
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
    list_commits "$@"
    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    for SUBMODULE in $SUBMODULES; do
        pushdir "$SUBMODULE"
        list_commits "$@"
        popdir 
    done
}

function tickets() {
    AUTHOR=${1:-$(git config user.name)}
    printf "\n\033[92mTickets for: \033[94m%s\033[0m\n\n" "$AUTHOR"
    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    # shellcheck disable=SC2016
    COMMAND='git log --all --author="$AUTHOR" --format="%s" --no-merges'
    {
        eval "$COMMAND" #n
        for SUBMODULE in $SUBMODULES; do
            pushdir "$SUBMODULE"
            eval "$COMMAND"
            popdir
        done
    } | grep -oE "[A-Za-z]+\/\d+" \
      | grep -oE "[0-9]+" \
      | sort -n -u \
      | xargs -I {} printf "https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%%20Dog/Backlog%%20items/?workitem=\033[92m{}\033[0m\n"
    printf "\n"
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
    FILE=$(git rev-parse --show-toplevel)/PayAtPump/PayAtPump/CustomLocation.gpx
    skip "$FILE"

    LOCATIONS=()
    NAMES=()
    LATITUDINES=()
    LONGITUDINES=()

    LOCATIONS=(
        'IBM Bucharest;44.4356676;26.0544182'
        'IBM Brasov;45.6687406;25.6194894'
        'NL Site;51.9386;4.1083'
        'Aus Site;-37.821067;144.966071'
        'US one car wash;41.264578;-96.161076'
    )

    for LOCATION in "${LOCATIONS[@]}"; do
        IFS=";" read -r -a arr <<< "${LOCATION}"
        NAMES=("${NAMES[@]}" "${arr[0]}")
        LATITUDINES=("${LATITUDINES[@]}" "${arr[1]}")
        LONGITUDINES=("${LONGITUDINES[@]}" "${arr[2]}")
    done

    select NAME in "${NAMES[@]}"; do
        if [[ -n $NAME ]]; then
            (( INDEX = REPLY-1 ))
            break
        else
            printf "Wrong selection.\n"
        fi
    done
    NAME=${NAMES[$INDEX]}
    LAT=${LATITUDINES[$INDEX]}
    LONG=${LONGITUDINES[$INDEX]}

    cat <<EOF > "$FILE"
<?xml version="1.0"?>
<gpx version="1.1" creator="Xcode">
    <wpt lat="$LAT" lon="$LONG"></wpt>b<!--Custom location: $NAME-->
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

    heading 'Updating brew cask...'
    brew cask upgrade

    heading 'Updating cocoapods...'
    pod repo update
}

function completions() {
    PREFIX=$(brew --prefix)
    FILES=(
        "etc/bash_completion"
        "etc/bash_completion.d/brew"
        "etc/bash_completion.d/tmux"
        "etc/bash_completion.d/bundler"
        "etc/bash_completion.d/gem"
        "etc/bash_completion.d/gradle"
        "etc/bash_completion.d/carthage"
        "etc/bash_completion.d/git-completion.bash"
        "etc/bash_completion.d/tig-completion.bash"
        "etc/bash_completion.d/youtube-dl.bash-completion"
        "opt/bash-git-prompt/share/gitprompt.sh"
    )
    for FILE in "${FILES[@]}"; do
        # shellcheck disable=SC1090
        source "$PREFIX/$FILE" || printf "Error: Completion file not found: ${RED}%s${NORMAL}\n" "$FILE" >&2
    done
}

completions
