export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"

eval "$(jenv init -)"
eval "$(rbenv init -)"

alias ebx="vim ~/.bash_profile_unix"

b() {
    change_to_ios_folder
    cart
    xcodebuild build -workspace Cura.xcworkspace -scheme Cura -sdk iphonesimulator12.1 -configuration Debug | xcpretty
}

change_to_ios_folder() {
    cd $(git rev-parse --show-toplevel)/ios
}

endpoint() {
    if [ -z "$1" ]; then
        server_endpoint="pc-6384"
    else
        server_endpoint=$1
    fi

    current_folder=$(git rev-parse --show-toplevel)/ios/LocalConfiguration
    command pushd $current_folder > /dev/null
    echo "http://172.20.17.12/CURA/$server_endpoint" > config.default.txt
    skip $current_folder/config.default.txt
    command popd > /dev/null
    echo -e "Endpoint server changed to http://172.20.17.12/CURA/\033[92m$server_endpoint\033[0m."
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