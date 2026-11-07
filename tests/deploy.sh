#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' 0
mkdir -p "$tmp/packages/shell/.config/app" "$tmp/home"
printf 'config\n' > "$tmp/packages/shell/.config/app/config"
printf 'new\n' > "$tmp/packages/shell/.zshrc"

sh "$root/deployment/deploy.sh" "$tmp/packages/shell" "$tmp/home"
test -L "$tmp/home/.config/app/config"
test "$(cat "$tmp/home/.zshrc")" = new
sh "$root/deployment/deploy.sh" "$tmp/packages/shell" "$tmp/home"

mkdir -p "$tmp/conflict-home"
printf 'existing\n' > "$tmp/conflict-home/.zshrc"
printf '%s\n' '--adopt' > "$tmp/conflict-home/.stowrc"
if (cd "$tmp/conflict-home" && HOME="$tmp/conflict-home" sh "$root/deployment/deploy.sh" "$tmp/packages/shell" "$tmp/conflict-home"); then
    printf 'deployment unexpectedly accepted a conflict\n' >&2
    exit 1
fi
test "$(cat "$tmp/conflict-home/.zshrc")" = existing
test ! -e "$tmp/conflict-home/.config"
test "$(cat "$tmp/packages/shell/.zshrc")" = new

printf 'Stow deployment tests passed\n'
