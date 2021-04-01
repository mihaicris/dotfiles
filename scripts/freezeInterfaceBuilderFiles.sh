#!/usr/bin/env zsh

find . \
    -path "./Pods/*" \
    -prune -o \
    -type f \
    \( -name "*.xib" -or -name "*.storyboard" \) \
    -exec sed -i '' 's/propertyAccessControl=\"none\"/propertyAccessControl=\"all\"/' {} \;

