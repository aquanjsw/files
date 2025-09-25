#!/bin/bash
#
WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKDIR"
# Path relative to this Pepo
SERVER_HOME=$(find * -maxdepth 0 -type d | grep -E "^(debian)$")
find ${SERVER_HOME} -type d | sed 's|/$||g' | xargs -I{} touch "{}/index.md"
