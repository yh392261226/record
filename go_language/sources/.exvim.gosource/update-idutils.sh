#!/bin/bash
export DEST="./.exvim.gosource"
export TOOLS="/Users/json/.runtime/exvim/vimfiles/tools/"
export TMP="${DEST}/_ID"
export TARGET="${DEST}/ID"
sh ${TOOLS}/shell/bash/update-idutils.sh
