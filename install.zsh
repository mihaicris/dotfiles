#! /usr/bin/env zsh

SCRIPT=$(dirname "$0")
SOURCE_PATH="$(cd "$SCRIPT" || exit 1 ; pwd -P )/Source"

pushd "$SOURCE_PATH" >/dev/null || { printf "Error. Exiting.." >&2 ; exit 1 }

FILES=$(find . -type f -print | sed "s|^\./||" )
FILES=(${(f)FILES})

for FILE in $FILES; do
    print "Creating symbolic link" "${LIGHT_BLUE}${HOME}/$FILE${NORMAL}"
    [[ -f $FILE ]] && ln -f -s "$SOURCE_PATH/$FILE" ~/"$FILE"
done

popd >/dev/null || { printf "Error. Exiting.." >&2 ; exit 1 }

echo "Done."
