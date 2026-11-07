#!/bin/sh
set -eu

if [ "$#" -ne 4 ]; then
    printf 'Usage: sh deployment/replace.sh PACKAGE HOME RELATIVE_PATH BACKUP_DIRECTORY\n' >&2
    exit 2
fi

package=$(CDPATH= cd -- "$1" && pwd -P)
home=$(CDPATH= cd -- "$2" && pwd -P)
relative=$3
case /$relative/ in
    //*) printf 'Path must be relative to the home directory.\n' >&2; exit 2 ;;
    */../*|*/./*|*//* ) printf 'Path must not contain empty, . or .. components.\n' >&2; exit 2 ;;
esac
if [ -z "$relative" ] || [ "$relative" = / ]; then
    printf 'Select a path inside the home directory.\n' >&2
    exit 2
fi
if [ ! -e "$package/$relative" ] && [ ! -L "$package/$relative" ]; then
    printf 'Selected path does not exist in the package: %s\n' "$relative" >&2
    exit 2
fi

target=$home/$relative
parent=$(dirname -- "$target")
physical_parent=$(CDPATH= cd -- "$parent" && pwd -P)
if [ "$parent" != "$physical_parent" ]; then
    printf 'Refusing to follow a symlinked parent: %s\n' "$parent" >&2
    exit 2
fi
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
backup=$(sh "$script_dir/backup.sh" "$target" "$4")
printf 'Backup of %s: %s/item\n' "$target" "$backup" >&2

# Preserve the original as well as the copy instead of deleting it. If Stow
# fails, both remain available for manual recovery.
if ! mv "$target" "$backup/original"; then
    printf 'Could not move original; backup remains at %s/item\n' "$backup" >&2
    exit 1
fi
if ! sh "$script_dir/deploy.sh" "$package" "$home"; then
    printf 'Deployment failed. Original: %s/original; backup: %s/item\n' "$backup" "$backup" >&2
    exit 1
fi
