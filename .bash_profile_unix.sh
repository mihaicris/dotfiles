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

b() {
    change_to_ios_folder
    cart
    xcodebuild build -workspace Cura.xcworkspace -scheme Cura -sdk iphonesimulator12.1 -configuration Debug | xcpretty
}

t() {
    cd $(git rev-parse --show-toplevel)/
    bundler exec Fastlane ios tests
}

t1() {
    cd $(git rev-parse --show-toplevel)/
    xcodebuild clean build test \
        -workspace iOS/Cura.xcworkspace \
        -scheme "Cura" \
        -sdk iphonesimulator \
        -destination "platform=iOS Simulator,OS=12.1,name=iPad Pro (11-inch)" \
        -derivedDataPath /tmp/DerivedData \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        ONLY_ACTIVE_ARCH=YES \
        | xcpretty -r html
}

change_to_ios_folder() {
    cd $(git rev-parse --show-toplevel)/ios
}

oo() {
    xed $(git rev-parse --show-toplevel)/ios
}

oos() {
    xed .
}

ooa() {
    studio $(git rev-parse --show-toplevel)/client
}

cart() {
    change_to_ios_folder
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

cart_new() {
    change_to_ios_folder
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain org.swift.5120190930a
}

cart_update() {
    change_to_ios_folder
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

cart_update_new() {
    change_to_ios_folder
    carthage update --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain org.swift.5120190930a
}


addBashCompletion() {
    if [ -f $1 ]; then
        . $1
    else
        echo "Warning, bash completion file not found: $1"
    fi
}

xcode() {
    sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"
    cp /Users/cris/.dotfiles/xcode/keybindings/Custom11.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

xcode10() {
    sudo xcode-select -s "/Applications/Xcode10.1.app/Contents/Developer"
    cp /Users/cris/.dotfiles/xcode/keybindings/Custom10.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
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
