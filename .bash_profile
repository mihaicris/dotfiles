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

heading() {
	#MAG='\033[0;35m'
	#CLR='\033[0m'
	echo ""
	echo "========================================="
	#echo "${MAG}** $@ **${CLR}"
	echo "$@"
	echo "========================================="
	echo ""
}

kill() {
	heading "TERMINATING PROCESSES"
	taskkill //F //IM node.exe //IM java.exe
	# alternativa: wmic Path win32_process Where "CommandLine Like '%%java%%'" call terminate
}

database() {
	heading "UPDATE LOCAL SETTINGS"
	#cd $(git rev-parse --show-toplevel)
	#sed -b -i 's/DC1-ORAC005/buc-proj001/' services/gradle.properties
	#sed -b -i 's/DC1-ORAC005/buc-proj001/' webclient/admin/gradle.properties
	#sed -b -i 's/DC1-ORAC005/buc-proj001/' webclient/depot/gradle.properties
}

server() {
	heading "STARTING FHIR SERVER"
	cd $(git rev-parse --show-toplevel)/services
	./gradlew installServer
}

keycloak() {
	heading "STARTING KEYCLOAK SERVER"
	cd $(git rev-parse --show-toplevel)/keycloak
	./gradlew installServer
}

depot() {
	heading "STARTING DEPOT SERVER"
	cd $(git rev-parse --show-toplevel)/services
	./gradlew installServerDepot
}

webclient() {
	heading "STARTING WEB CLIENT"
	cd $(git rev-parse --show-toplevel)/webclient
	sed -b -i 's/da_DK/en_US/' admin/src/main/assets/angular/app.js
	./gradlew bootRun
}

integrations() {
	heading "STARTING INTEGRATIONS SERVER"

	echo "Task: Patch URL of Integrations Database ( -> DB in Romania)"

	cd $(git rev-parse --show-toplevel)/integrations/datasource/src/test/resources/config/
	sed -b -i 's/dc1-orac005/buc-proj001/' datasource.properties
	sed -b -i 's/dc1-orac005/buc-proj001/' datasource-oracle.properties

	cd $(git rev-parse --show-toplevel)/integrations
	#./installServer.bat
	./gradlew clean dbClean dbBootstrap installTestServer :signaturecentral:deploy :cpr:deploy :fmk:deploy startTestServer
	#./gradlew clean installTestServer :signaturecentral:deploy :cpr:deploy :fmk:deploy startTestServer
	#./gradlew installTestServer startTestServer
}

load_catalog_data() {
	heading "LOAD CATALOG DATA"

	cd $(git rev-parse --show-toplevel)/integrations/build/eap/jboss-eap-7.0/standalone/deployments/

	echo "Task: Undeploy CPR module"
	cd ../deployments/
	rm cpr.war.deployed
	while [ ! -f cpr.war.undeployed ]; do sleep 1; done

	echo "Task: Patch CPR environment properties"
	cd ../properties/
	sed -b -i 's/SKRS_MAX_RECORDS_PER_ITERATION=100/SKRS_MAX_RECORDS_PER_ITERATION=2000/' cpr-environment.properties
	sed -b -i 's/SKRS_MAX_RECORDS_PER_TRIGGERING=100/SKRS_MAX_RECORDS_PER_TRIGGERING=-1/' cpr-environment.properties

	echo "Task: Redeploy CPR module"
	cd ../deployments/
	rm cpr.war.undeployed
	while [ ! -f cpr.war.deployed ]; do sleep 1; done

	echo "Task: Load Catalog Data"
	curl "http://localhost:8100/cpr/forceSkrsImport/"

	cd $(git rev-parse --show-toplevel)/
	echo "Done."
}

alias ss="kill ; server"
alias sw="kill ; server && webclient"
alias skw="kill ; server && keycloak && webclient"
alias si="kill ; server && integrations"
alias siw="kill ; server && integrations && webclient"
alias sic="kill ; server && integrations && load_catalog_data"
alias sicw="kill ; server && integrations && load_catalog_data && webclient"
