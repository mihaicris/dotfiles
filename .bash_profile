export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Java Versions
eval "$(jenv init -)"

# Ruby Versions
eval "$(rbenv init -)"
# Bash Complewtions

function addBashCompletion { 
	if [ -f $1 ] 
	then 
		. $1 
	else 
		echo "Warning, bash completion file not found: $1" 
	fi 
}

addBashCompletion $(brew --prefix)/etc/bash_completion
addBashCompletion $(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh
addBashCompletion $(brew --prefix)/etc/bash_completion.d/git-completion.bash
addBashCompletion $(brew --prefix)/etc/bash_completion.d/tig-completion.bash
addBashCompletion $(brew --prefix)/etc/bash_completion.d/brew
addBashCompletion $(brew --prefix)/etc/bash_completion.d/launchctl
addBashCompletion $(brew --prefix)/etc/bash_completion.d/carthage
addBashCompletion $(brew --prefix)/etc/bash_completion.d/youtube-dl.bash-completion

# Edit this file
alias eb="vim ~/.bash_profile"
# Reload this file
alias rb="source ~/.bash_profile"
#Edit vimrc file
alias ev="vim ~/.vimrc"
alias ls="ls -G"
alias ll="ls -Flh"
alias lla="ll -A"
alias ..="cd .. && ll"

# === GIT ALIASES ===
alias gb="git branch"
alias gba="git branch --all"
alias gco="git checkout"
alias ggfa="git fetch --all --progress && git status"
alias gclean="git clean -xdf -e Carthage/"
alias gcfl="git diff --name-only --diff-filter=U | uniq | xargs $EDITOR"
alias gbf="git branch --contains" # argument a commit hash
alias gtf="git tag --contains" # argument a commit hash
alias gcount="git rev-list --count" # argument a branch name
alias br="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)  %(align:40,left)%(color:yellow)%(authorname)%(end)%(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes"

# checks for any files flagged w/ --skip-worktree alias
alias check="git ls-files -v|grep '^S'"

alias ytp="youtube-dl --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15'"

# add --skip-worktree flag to file
skip() {  git update-index --skip-worktree "$@";  git status; }

# remove --skip-worktree flag from file
unskip() {  git update-index --no-skip-worktree "$@";  git status; }

b() { 
	cart 
	xcodebuild build -workspace Cura.xcworkspace -scheme Cura -sdk iphonesimulator12.1 -configuration Debug | xcpretty 
}

hh() { git checkout HEAD~1; }


change_to_ios_folder() {
	cd $(git rev-parse --show-toplevel)/ios
}

t() {
	cd $(git rev-parse --show-toplevel)/
	bundler exec Fastlane ios tests
}

oo() {
	change_to_ios_folder
	xed .
}

cart() { 
	change_to_ios_folder
	carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

cart_update() {
	change_to_ios_folder
	carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

cart_release() {
	change_to_ios_folder
	carthage bootstrap --platform iOS --configuration Release --cache-builds --no-use-binaries
}
