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
alias pdot="pushd ~/.dotfiles && git pull && popd && rb"
alias edot="pdot && subl ~/.dotfiles/.bash_profile"

alias ytp="youtube-dl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl="git diff --name-only --diff-filter=U | uniq | xargs $EDITOR"
alias gcount="git rev-list --count" # argument a branch name
alias gtf="git tag --contains" # argument a commit hash
alias gcm="git add -A && git commit"
alias ss="git status"

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
UNDERLINE=$(tput smul)
NORMAL=$(tput sgr0)

function pushd() {
    command pushd "$@" >/dev/null
}

function popd() {
    command popd "$@" >/dev/null
}

function heading() {
    echo -e "\n\033[7m\033[034m$@\033[0m\n"
}

function gr() {
    if $(git rev-parse &>/dev/null ); then 
        heading 'Changing to git root folder'
        cd $(git rev-parse --show-toplevel)
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
    heading 'Pruning branches'
    git remote prune origin
}

function fetch() {
    heading 'Fetching remotes'
    git fetch --prune --all --tags
}

function status() {
    heading 'Status'
    git status
    echo ""
}

function unstage() {
    heading 'Unstaging local changes'
    files=`git diff --name-only --cached`
    if [[ ${#files} -gt 0 ]]; then
        git diff --name-only --cached | cat
        echo ""
        git reset HEAD --quiet
    else
        echo -e "* Nothing to unstage."
    fi
}

function discard() {
    heading 'Discarding local changes'
    pushd $(git rev-parse --show-toplevel)
    files=`git diff --name-only`
    if [[ ${#files} -gt 0 ]]; then
        git diff --name-only | cat
        git checkout . --quiet
    else
        echo -e "* Nothing to discard."
    fi
    popd
}

function clean_untracked() {
    heading 'Cleaning untracked files'
    files=`git clean -fdn`
    if [[ ${#files} -gt 0 ]]; then
        git clean -fd
    else
        echo -e "* Nothing to clean."
    fi
}

function gclean() {
    heading 'Cleaning ignored files'
    pushd $(git rev-parse --show-toplevel)
    files=`git clean -xdfn -e Carthage/`
    if [[ ${#files} -gt 0 ]]; then
        git clean -xdf -e Carthage/
    else
        echo -e "* Nothing to clean."
    fi
    popd
}

function recreate_files() {
    heading 'Recreating all files'
    pushd $(git rev-parse --show-toplevel)
    git rm --cached -r .
    git reset --hard
    popd
}

function unskipAll() {
    heading 'Reactivating skipped files from git'
    files=`git ls-files -v | grep '^S' | cut -d ' ' -f 2`
    if [[ ${#files} -gt 0 ]]; then
        git ls-files -v | grep '^S' | cut -d ' ' -f 2
        echo ""
        git ls-files -v | grep '^S' | cut -d ' ' -f 2 | xargs git update-index --no-skip-worktree
    else 
        echo -e "* Nothing to reactivate."
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
    echo ""
}

function check() {
    heading 'Skipped files'
    git ls-files -v | grep '^S' | cut -d ' ' -f 2
    echo ""
}

function sedi() {
    sed --version >/dev/null 2>&1 && sed -b -i -- "$@" || sed -i "" "$@"
}

function ccb() {
    criteria="$@"
    prefix="origin/"

    if [ -z "$criteria" ]
    then
          echo -e "\n\033[92mPlease specifiy a string contained in the branch.\033[0m\n"
    else
        branch_name_remote=$(git branch -r | grep $criteria)
        count=`git branch -r | grep $criteria | wc -l`
        if [[ $count -lt 1 ]]; then
            echo -e "\nThere are no remote branches containing \033[91m$criteria\033[0m.\n"
            return 0
        fi

        if [[ $count -gt 1 ]]; then
            echo -e "\nThere are multiple branches containing \033[91m$criteria\033[0m:"
            echo -e "\033[34m"
            git branch -r | grep $criteria
            echo -e "\033[0m"
            return 0
        fi
        branch_name=`echo $branch_name_remote | sed 's/^origin\///'`
        isLocalBranch=`git branch | grep $branch_name`
        if [ ! -z "$isLocalBranch" ]
        then
            status=`git checkout -q $branch_name`
            status=$?
            if [ $status -eq 0 ] ; then
                echo -e "\nLocal branch \033[92m$branch_name\033[0m successfuly checked out.\n"
                return 0
            else
                echo -e "\nCould not checkout branch:\n\033[34m$branch_name\033[0m.\n"
                return 1
            fi
        else
            status=`git checkout -q -b $branch_name --track $branch_name_remote`
            status=$?
            if [ $status -eq 0 ] ; then
                echo -e "\nRemote branch \033[92m$branch_name\033[0m successfuly checked out locally.\n"
                return 0
            fi
        fi
    fi
}

function devteam() {
    if [ -z "$1" ]; then
        team="S8V3V9GFN2"
    else
        team=$1
    fi
    pushd $(git rev-parse --show-toplevel)
    files=$(find . -name "project.pbxproj" | xargs)
    sedi "s/\(DEVELOPMENT_TEAM = \).*\;/\1$team\;/g" $files
    popd
}

function transform_ts_to_mp4() {
    for a in *.ts; do
        ffmpeg -i "$a" -c copy "${a%.*}.mp4"
    done
}

function ff() {
    ggfa
    heading "Fast forwarding all worktrees"
    paths=$(git worktree list --porcelain  | grep worktree | awk '{print $2}')
    for path in $paths
    do
        printf "\033[92m* Fast forwarding \033[94m$path"
        pushd $path
        isDetached=$(git symbolic-ref -q HEAD)
        if [[ -z $isDetached ]]; then
            printf "\n\033[91mSkipping (detached state).\033[0m\n\n"
        else
            current_branch=$(git rev-parse --abbrev-ref HEAD)
            printf " \033[93m[$current_branch]\033[0m\n"
            git pull
            echo ""
        fi
        popd
    done
}

function gg() {
    heading "Pull Submodule" 
    if [ -z "$1" ]; then
        branch="apimaindevelopment"
    else
        branch=$1;
    fi
    git pull
    git submodule foreach bash -c "git fetch --quiet --all -p && git switch --quiet $branch && git pull" 
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
    
    GIT_OUTPUT=$(eval ${GIT_LOG_COMMAND} 2>/dev/null)
    
    if [[ ! -z "$GIT_OUTPUT" ]]; then
        if [[ $HAS_OUTPUT == "true" ]]; then
            echo ""
        fi
        printf "\033[37m\033[4m$(basename $(pwd))\033[0m\n"
        printf "$GIT_OUTPUT\n"
        HAS_OUTPUT="true"
    fi
}

function daily() {
    HAS_OUTPUT="false"
    list-commits $@
    submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    for submodule in $submodules
    do
        pushd $submodule
        list-commits $@
        popd
    done
}

function tickets() {
    if [ -z "$1" ]; then
        author=$(git config user.name);
        name=$author
    else
        if [ $1 == "0" ]; then
            name="All authors"
        else
            name=$1
        fi
        author=$1
    fi
    printf "\n\033[92mTickets for: \033[94m$name\033[0m\n\n"
    daily $author | \
        grep -oE "/[0-9]{5,}" | \
        grep -oE "[0-9]+" | \
        sort | \
        uniq | \
        xargs -I {} printf "https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%%20Dog/Backlog%%20items/?workitem=\033[92m{}\033[0m\n"
    echo ""
}

function oo() {
    xed .
}

function cart() {
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
    ios_patches
}

function cart_toolchain() {
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain $1 
}

function cart_update() {
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

function cart_update_toolchain() {
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain $1
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
        open https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%20Dog/Backlog%20items/?workitem=$1
    fi
}

function def() {
    open https://bp-vsts.visualstudio.com/BPme/_queries/query/6661bd32-ba84-4689-84ba-6850653f115e/
}

function work() {
    open https://bp-vsts.visualstudio.com/BPme/_workitems/assignedtome/
}

function gpx() {
    file_location=$(git rev-parse --show-toplevel)/PayAtPump/PayAtPump/CustomLocation.gpx
    cat <<EOF > $file_location 
<?xml version="1.0"?>
<gpx version="1.1" creator="Xcode">
    <wpt lat="44.4356676" lon="26.0544182"></wpt>
</gpx>
EOF
    skip $file_location
}

function search() {
   git log -S$1 
}

function addBashCompletion() {
    if [ -f $1 ]; then
        . $1
    else
        echo "Warning, bash completion file not found: $1"
    fi
}

addBashCompletion $(brew --prefix)/etc/bash_completion
addBashCompletion $(brew --prefix)/etc/bash_completion.d/brew
addBashCompletion $(brew --prefix)/etc/bash_completion.d/tmux
addBashCompletion $(brew --prefix)/etc/bash_completion.d/carthage
addBashCompletion $(brew --prefix)/etc/bash_completion.d/git-completion.bash
addBashCompletion $(brew --prefix)/etc/bash_completion.d/launchctl
addBashCompletion $(brew --prefix)/etc/bash_completion.d/tig-completion.bash
addBashCompletion $(brew --prefix)/etc/bash_completion.d/youtube-dl.bash-completion
addBashCompletion $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh
