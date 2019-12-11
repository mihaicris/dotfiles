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
    endpoint
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
}

cartp() {
    change_to_ios_folder
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries
    ios_patches
    endpoint
    carthage build --platform iOS --configuration Debug swift-smart
}

cart_new() {
    change_to_ios_folder
    carthage bootstrap --platform iOS --configuration Debug --cache-builds --no-use-binaries --toolchain org.swift.50201912021a
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
    cp ~/.dotfiles/xcode/keybindings/Custom11.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

xcode10() {
    sudo xcode-select -s "/Applications/Xcode10.1.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom10.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

xcodebeta() {
    sudo xcode-select -s "/Applications/Xcode-beta.app/Contents/Developer"
    cp ~/.dotfiles/xcode/keybindings/Custom11.idekeybindings ~/Library/Developer/Xcode/UserData/KeyBindings/Mihai.idekeybindings
}

ios_patches() {
    heading "Applying patches to iOS Code"
    file=$(git rev-parse --show-toplevel)/ios/CuraCore/CuraCore/logging/CuraLogger.swift
    perl -i -p0e 's/private init().*public func setup/private init() { console = ConsoleDestination() }\n\n    public func setup/s' $file
    skip $file
    echo -e "* Patched \033[92m$file\033[0m (silenced logger).\n"
    file=$(git rev-parse --show-toplevel)/ios/Carthage/Checkouts/swift-smart/Swift-FHIR/Sources/Models/FHIRAbstractBase.swift
    perl -i -pe 's/^.*fhir_warn\(error\.description\).*$//s' $file
    echo -e "* Patched \033[92m$file\033[0m (silenced swiftfhir warnings).\n"
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
