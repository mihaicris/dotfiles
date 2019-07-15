export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

source ~/.bash_profile_common.sh

mingw64=$(uname -a | grep MINGW64)

if [[ -n "$mingw64" ]]
then
    source ~/.bash_profile_mingw64.sh
else
    source ~/.bash_profile_unix.sh
fi

alias ..="cd .. && ll"
alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias edot="subl ~/.dotfiles"
alias dotf="cd ~/.dotfiles && git pull"
alias gb="git branch"
alias gba="git branch --all"
alias gbf="git branch --contains" # argument a commit hash
alias gcfl="git diff --name-only --diff-filter=U | uniq | xargs $EDITOR"
alias gco="git checkout"
alias gcount="git rev-list --count" # argument a branch name
alias gtf="git tag --contains" # argument a commit hash
alias ll="ls -Flh"
alias lla="ll -A"
alias ls="ls -G"
alias rb="source ~/.bash_profile"
alias hh="git checkout HEAD~1"
alias ytp="youtube-dl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"
