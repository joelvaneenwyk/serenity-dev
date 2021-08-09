#!/bin/bash

cwd=$(pwd)

SERENITY_DEV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SERENITY_DEV_DIR/serenity" || true
returnValue=0

if ! Meta/lint-ci.sh; then
    returnValue=1
fi

cd "$cwd" || true

exit $returnValue
