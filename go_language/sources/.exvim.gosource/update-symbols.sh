#!/bin/bash
export DEST="./.exvim.gosource"
export TOOLS="/Users/json/.runtime/exvim/vimfiles/tools/"
export TMP="${DEST}/_symbols"
export TARGET="${DEST}/symbols"
sh ${TOOLS}/shell/bash/update-symbols.sh
