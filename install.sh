#! /usr/bin/env bash

SCRIPT=$(dirname "$0")
SOURCE_PATH="$(cd "$SCRIPT" || exit 1 ; pwd -P )/Source"
pushd "$SOURCE_PATH" >/dev/null || printf "Error. Exiting.." >&2
FILES=$(find . -type f -print | sed "s|^\./||" )
for FILE in $FILES; do
    ln -f -s "$SOURCE_PATH/$FILE" ~/"$FILE"
done
popd || exit 1
