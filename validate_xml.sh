#!/usr/bin/env bash

GIT_COMMITS=${GIT_COMMITS:-master}
REGML_PY=${REGML_PY:-regml.py}

# Fail if this command fails.
set -e
echo Using git commit range $GIT_COMMITS
files=`git diff --name-only --diff-filter=AM $GIT_COMMITS`
set +e

errcode=0

while read -r f; do
    # Skip empty lines.
    [[ -z "$f" ]] && continue

    # Skip lines that don't match regulation/*.xml or notice/*.xml.
    if ! [[ "$f" =~ ^(regulation|notice)/.*\.xml ]]; then
        echo Skipping "$f"
        continue
    fi

    echo Validating "$f"
    "$REGML_PY" validate "$f"
    errcode=$(($errcode | $?))
done <<< "$files"

exit $errcode
