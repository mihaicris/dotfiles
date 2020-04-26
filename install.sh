#! /usr/bin/env bash

SCRIPT=$(dirname "$0")
SOURCE_PATH=$(cd "$SCRIPT" ; pwd -P )/Source
pushd $SOURCE_PATH >/dev/null || exit "Error. Exiting.." >&2
FILES=$(find . -type f -print | sed "s|^\./||" )
for FILE in $FILES; do
    ln -s $SOURCE_PATH/$FILE ~/"$FILE"
done
popd
