export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"

eval "$(jenv init -)"
eval "$(rbenv init -)"

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

oo() {
    xed .
}

cart() {
    change_to_ios_folder
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
    ios_patches
    endpoint
}

cart_new() {
    change_to_ios_folder
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain $1 
    endpoint
}

cart_update() {
    change_to_ios_folder
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries
    endpoint
}

cart_update_new() {
    change_to_ios_folder
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain $1
    endpoint
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

