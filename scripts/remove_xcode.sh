#!/bin/zsh

# Function to remove directories
remove_directory() {
    if [ -d "$1" ]; then
        echo "Removing $1"
        rm -rf "$1"
    else
        echo "$1 does not exist"
    fi
}

# Remove Xcode application
echo "Removing Xcode application..."
sudo rm -rf /Applications/Xcode-15.4.0.app
sudo rm -rf /Applications/Xcode-16.0.0.app

# Remove derived data, archives, and iOS device support
remove_directory "$HOME/Library/Developer/Xcode"
remove_directory "$HOME/Library/Caches/com.apple.dt.Xcode"
remove_directory "$HOME/Library/Application Support/MobileSync/Backup"
remove_directory "$HOME/Library/Developer/CoreSimulator"

# Remove additional support files
remove_directory "$HOME/Library/Developer/Xcode/iOS DeviceSupport"
remove_directory "$HOME/Library/Developer/Xcode/DerivedData"
remove_directory "$HOME/Library/Developer/Xcode/Archives"

# Remove command line tools
echo "Removing Command Line Tools..."
sudo rm -rf /Library/Developer/CommandLineTools
sudo rm -rf /Library/Developer/CoreSimulator
sudo rm -rf /System/Library/PrivateFrameworks/CoreSimulator.framework

# Remove Swift Playgrounds and documentation
remove_directory "$HOME/Library/Containers/com.apple.dt.Xcode"
remove_directory "$HOME/Library/Containers/com.apple.dt.xcodebetaswiftui"
remove_directory "$HOME/Library/Preferences/com.apple.dt.Xcode.plist"
remove_directory "$HOME/Library/Preferences/com.apple.dt.xcodebetaswiftui.plist"

# Remove preferences and supporting files
remove_directory "$HOME/Library/Preferences/com.apple.dt.Xcode.plist"
remove_directory "$HOME/Library/Preferences/com.apple.dt.xcodebuild.plist"
remove_directory "$HOME/Library/Preferences/com.apple.dt.xcode.sourcekit.supported.plist"

# Remove SPM cache
echo "Removing Swift Package Manager caches..."
remove_directory "$HOME/Library/Caches/org.swift.swiftpm"
remove_directory "$HOME/Library/Caches/org.swift.swiftpm/repositories"
remove_directory "$HOME/Library/Caches/org.swift.swiftpm/repositories.git"

# Empty the Trash
echo "Emptying the Trash..."
rm -rf ~/.Trash/*

# Verify removal
echo "Verifying Xcode removal..."
xcode-select --print-path || echo "Xcode has been removed successfully."

echo "All traces of Xcode and SPM caches have been removed."
