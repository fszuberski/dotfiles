#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' 0
mkdir -p "$tmp/home"

sh "$root/deployment/deploy.sh" "$root/stow/zsh" "$tmp/home"
test -L "$tmp/home/.zshrc"
grep -q '^ZSH_THEME="powerlevel10k/powerlevel10k"$' "$tmp/home/.zshrc"
if command -v zsh >/dev/null 2>&1; then
    zsh -n "$tmp/home/.zshrc"
else
    printf 'Zsh not installed; syntax check skipped.\n' >&2
fi
printf 'Zsh package deployment test passed\n'
