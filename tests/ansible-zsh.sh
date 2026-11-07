#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
test -f "$root/playbooks/zsh.yml"
test -f "$root/requirements.yml"
grep -q 'community.general.pacman:' "$root/playbooks/zsh.yml"
grep -q 'community.general.homebrew:' "$root/playbooks/zsh.yml"
grep -q 'community.general' "$root/requirements.yml"
if command -v ansible-playbook >/dev/null 2>&1; then
    ansible-playbook -i localhost, "$root/playbooks/zsh.yml" --syntax-check
else
    printf 'Ansible not installed; playbook syntax check skipped.\n' >&2
fi
printf 'Zsh playbook checks passed\n'
