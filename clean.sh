#!/usr/bin/env nix-shell
#!nix-shell -i bash -p figlet
set -euo pipefail

function banner {
	echo
	figlet -k -w 132 -f standard "$1" | sed -e 's/^/# /'
	echo
}

banner 'Collect Garbage'
nix-collect-garbage -d

banner 'Clean Store'
nix-store --gc

banner 'Optimize Store'
nix-store --optimize
