autoload -U promptinit
promptinit
#prompt adam1

source "/usr/local/opt/zsh-git-prompt/zshrc.sh"
PROMPT='%{$fg[green]%}%{$reset_color%} %~ $(git_super_status) '
alias ..="cd .. && ll"
alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"
alias edot="pdot && vim ~/.dotfiles/.bash_profile"
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
alias pdot="pushdir ~/.dotfiles && git pull --quiet && popdir && rb"
alias rb="source ~/.bash_profile"
alias s="git status"
alias ytp="youtube-dl --socket-timeout 10 --external-downloader aria2c --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

