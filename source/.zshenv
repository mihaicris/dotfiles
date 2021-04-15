#! /usr/bin/env zsh

#Global
emulate -L zsh

# Colors Aliases
NORMAL="\033[0m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
LIGHT_GRAY="\033[37m"
DARK_GRAY="\033[90m"
LIGHT_RED="\033[91m"
LIGHT_GREEN="\033[92m"
LIGHT_YELLOW="\033[93m"
LIGHT_BLUE="\033[94m"
LIGHT_MAGENTA="\033[95m"
LIGHT_CYAN="\033[96m"
WHITE="\033[97m"
BG_BLUE="\033[44m"
BG_LIGHT_BLUE="\033[104m"
BG_DARK_GRAY="\033[100m"
if [ -e /Users/mihaicris/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/mihaicris/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
