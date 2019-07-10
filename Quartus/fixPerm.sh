#!/bin/sh
# This script fixes permissions if they are ever reset to 000.
# Useful when using WSL for git and Quartus on Windows.

find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
