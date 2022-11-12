#!/usr/bin/env nix-shell
#!nix-shell -i bash -p figlet
set -euo pipefail

function banner {
  echo
  figlet -k -w 132 -f standard "$1" | sed -e 's/^/# /'
  echo
}

# update flakes
banner 'Flake Update'
nix flake update

# switch
banner 'Rebuild Switch'
nixos-rebuild switch

