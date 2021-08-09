#!/bin/bash

SERENITY_DEV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SERENITY_SOURCE_DIR="$SERENITY_DEV_DIR/serenity"
TARGET=x86_64

echo "Serenity Development Root: '$SERENITY_DEV_DIR'"
echo "Serenity Source: '$SERENITY_SOURCE_DIR'"

# This is technically superfluous since the build command below already builds the toolchain, but it
# should be mostly a no-op the second time and this is good reference for how to build it manually
# if needed.
(cd "$SERENITY_SOURCE_DIR/Toolchain" && ARCH="$TARGET" ./BuildIt.sh)

# Intentionally not doing a full 'rebuild-toolchain' as it is time consuming and not really necessary
(cd "$SERENITY_SOURCE_DIR" && "Meta/serenity.sh" build "$TARGET")
