#!/bin/sh
# This script fixes permissions if they are ever reset to 000.
# Useful when using WSL for git and Quartus on Windows.

me=`basename "$0"`

find . -type d -exec chmod 755 {} +
find . -type f ! -name "$me" ! -name "*.sh" -exec chmod 644 {} +
