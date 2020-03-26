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
alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias edot="pdot && vim ~/.dotfiles/.bash_profile"
alias gb="git branch"
alias gba="git branch --all"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl="git diff --name-only --diff-filter=U | uniq | xargs $EDITOR"
alias gcount="git rev-list --count" # argument a branch name
alias gtf="git tag --contains" # argument a commit hash
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias pdot="pushd ~/.dotfiles && git pull && popd && rb"
alias rb="source ~/.bash_profile"
alias ytp="youtube-dl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

addBashCompletion() {
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

pushd() {
    command pushd "$@" > /dev/null
}

popd() {
    command popd "$@" > /dev/null
}

heading() {
    echo -e "\n\033[7m\033[034m$@\033[0m\n"
}

gr() {
    if $(git rev-parse &>/dev/null ); then 
        heading 'Changing to git root folder'
        cd $(git rev-parse --show-toplevel)
    fi
}

ggfa() {
    prune
    fetch
    status
}

rr() {
    unstage
    discard
    status
}

rrr() {
    unskipAll
    unstage
    discard
    status
}

rrrr() {
    unskipAll
    unstage
    discard
    clean_untracked
    status
}

rrrrr() {
    unskipAll
    unstage
    discard
    gclean
    status
}

prune() {
    heading 'Pruning branches'
    git remote prune origin
}

fetch() {
    heading 'Fetching remotes'
    git fetch --prune --all --tags
}

status() {
    heading 'Status'
    git status
    echo ""
}

unstage() {
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

discard() {
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

clean_untracked() {
    heading 'Cleaning untracked files'
    files=`git clean -fdn`
    if [[ ${#files} -gt 0 ]]; then
        git clean -fd
    else
        echo -e "* Nothing to clean."
    fi
}

gclean() {
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

recreate_files() {
    heading 'Recreating all files'
    pushd $(git rev-parse --show-toplevel)
    git rm --cached -r .
    git reset --hard
    popd
}

unskipAll() {
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

skip() {
    git update-index --skip-worktree "$@"
}

unskip() {
    git update-index --no-skip-worktree "$@"
}

hh() {
    heading "Detaching HEAD to previous commit"
    git checkout HEAD~1
    echo ""
}

check() {
    heading 'Skipped files'
    git ls-files -v | grep '^S' | cut -d ' ' -f 2
    echo ""
}

sedi() {
    sed --version >/dev/null 2>&1 && sed -b -i -- "$@" || sed -i "" "$@"
}

ccb() {
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

devteam() {
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

transform_ts_to_mp4() {
    for a in *.ts; do
        ffmpeg -i "$a" -c copy "${a%.*}.mp4"
    done
}

features() {
    if [ -z "$1" ]; then
        author="Mihai Cristescu"
    else
        author=$1
    fi

    git log --all --author="$author" --oneline | grep -o -E "\[CURA-\d*\]" | sort | uniq
}

ff() {
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

gg() {
   heading "Pull Submodule" 
   submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
   for submodule in $submodules
   do
      printf "\n\033[92m* Updating submodule: \033[94m$submodule\n"
      pushd $submodule
      rrrr
      git switch apimaindevelopment
      git pull
      popd
   done
}



oo() {
    xed .
}

cart() {
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
    ios_patches
}

cart_toolchain() {
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain $1 
}

cart_update() {
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

cart_update_toolchain() {
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain $1
}

xcode() {
    sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom11.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

xcode10() {
    sudo xcode-select -s "/Applications/Xcode10.3.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom10.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

xcodebeta() {
    sudo xcode-select -s "/Applications/Xcode-beta.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom11.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

owa() {
    open https://outlook.office.com/mail/inbox
}

p() {
    open https://bp-vsts.visualstudio.com/BPme/_apps/hub/ryanstedman.tfs-pullrequest-dashboard.tfs-pullrequest-dashboard
}

vst() {
    if [ -z "$1" ]; then
        open https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%20Dog/Backlog%20items
    else
        open https://bp-vsts.visualstudio.com/BPme/_boards/board/t/Mad%20Dog/Backlog%20items/?workitem=$1
    fi
}

def() {
    open https://bp-vsts.visualstudio.com/BPme/_queries/query/6661bd32-ba84-4689-84ba-6850653f115e/
}

work() {
    open https://bp-vsts.visualstudio.com/BPme/_workitems/assignedtome/
}

#gpx() {
#    output=$(git rev-parse --show-toplevel)/PayAtPump/PayAtPump/CustomLocation.gpx
#    cat <<-'EOF' >$output
#        <?xml version="1.0"?>
#        <gpx version="1.1" creator="Xcode">
#            <wpt lat="44.4356676" lon="26.0544182">
#            </wpt>
#        </gpx>
#    EOF
#    popd
#}

