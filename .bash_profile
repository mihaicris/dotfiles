export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

mingw64=$(uname -a | grep MINGW64)

if [[ -n "$mingw64" ]]
then
	source ~/.bash_profile_mingw64
else
	source ~/.bash_profile_unix
fi

alias ..="cd .. && ll"
alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias dotf="cd ~/.dotfiles && git pull"
alias eb="vim ~/.bash_profile"
alias ev="vim ~/.vimrc"
alias gb="git branch"
alias gba="git branch --all"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl="git diff --name-only --diff-filter=U | uniq | xargs $EDITOR"
alias gclean="git clean -xdf -e Carthage/"
alias gco="git checkout"
alias gcount="git rev-list --count" # argument a branch name
alias ggfa="git remote prune origin && git fetch --prune --all && git status"
alias gtf="git tag --contains" # argument a commit hash
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias rb="source ~/.bash_profile"
alias rr="git reset HEAD && git checkout . && git status"
alias ytp="youtube-dl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

hh() {
    git checkout HEAD~1
}

check() {
	git ls-files -v | grep '^S'
}

skip() { 
	git update-index --skip-worktree "$@"
    git status
}

unskip() { 
    git update-index --no-skip-worktree "$@"
    git status
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
                echo -e "\nCould not checkout branch\033[34m$branch_name\033[0m.\n"
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
