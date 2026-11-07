#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' 0
mkdir -p "$tmp/packages/shell" "$tmp/home" "$tmp/backups"
printf 'new\n' > "$tmp/packages/shell/.zshrc"
printf 'old\n' > "$tmp/home/.zshrc"

sh "$root/deployment/replace.sh" "$tmp/packages/shell" "$tmp/home" .zshrc "$tmp/backups"
test -L "$tmp/home/.zshrc"
test "$(cat "$tmp/home/.zshrc")" = new
set -- "$tmp"/backups/backup.*/item
test "$#" -eq 1
test "$(cat "$1")" = old

mkdir -p "$tmp/other-home" "$tmp/other-backups"
printf 'old\n' > "$tmp/other-home/.zshrc"
printf 'new\n' > "$tmp/packages/shell/.other"
printf 'conflict\n' > "$tmp/other-home/.other"
if sh "$root/deployment/replace.sh" "$tmp/packages/shell" "$tmp/other-home" .zshrc "$tmp/other-backups"; then
    printf 'replacement unexpectedly ignored another conflict\n' >&2
    exit 1
fi
set -- "$tmp"/other-backups/backup.*/original
test "$(cat "$1")" = old
test "$(cat "$tmp/other-home/.other")" = conflict
test ! -e "$tmp/other-home/.zshrc"

if sh "$root/deployment/replace.sh" "$tmp/packages/shell" "$tmp/home" ../outside "$tmp/backups"; then
    printf 'replacement unexpectedly accepted a path outside the home\n' >&2
    exit 1
fi
printf 'Replacement tests passed\n'
