#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' 0
mkdir -p "$tmp/home" "$tmp/backups"
printf 'original\n' > "$tmp/home/.zshrc"
backup=$(sh "$root/deployment/backup.sh" "$tmp/home/.zshrc" "$tmp/backups")
test -f "$backup/item"
test "$(cat "$backup/item")" = original
test "$(cat "$tmp/home/.zshrc")" = original
printf 'changed\n' > "$tmp/home/.zshrc"
test "$(cat "$backup/item")" = original

ln -s missing "$tmp/home/link"
backup_link=$(sh "$root/deployment/backup.sh" "$tmp/home/link" "$tmp/backups")
test -L "$backup_link/item"
test "$(readlink "$backup_link/item")" = missing
test -L "$tmp/home/link"

mkdir -p "$tmp/home/config/nested"
printf 'nested\n' > "$tmp/home/config/nested/file"
backup_dir=$(sh "$root/deployment/backup.sh" "$tmp/home/config" "$tmp/backups")
test "$(cat "$backup_dir/item/nested/file")" = nested
if sh "$root/deployment/backup.sh" "$tmp/home/config" "$tmp/home/config/nested"; then
    printf 'backup unexpectedly accepted a destination inside its source\n' >&2
    exit 1
fi

if sh "$root/deployment/backup.sh" "$tmp/home/missing" "$tmp/backups"; then
    printf 'backup unexpectedly accepted a missing source\n' >&2
    exit 1
fi
printf 'Backup tests passed\n'
