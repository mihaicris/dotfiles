#! /usr/bin/env zsh
set -x
SCRIPT=$(dirname "$0")
SOURCE_PATH="$(cd "$SCRIPT" || exit 1 ; pwd -P )/Source"
pushd "$SOURCE_PATH" >/dev/null || printf "Error. Exiting.." >&2
FILES=$(find . -type f -print | sed "s|^\./||" )
FILES=("${(f)FILES}")
for FILE in $FILES; do
    echo "Linking $FILE"
    ln -f -s "$SOURCE_PATH/$FILE" ~/"$FILE"
done
popd >/dev/null || exit 1
echo "Done."
set +x
