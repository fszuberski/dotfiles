#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
    printf 'Usage: sh deployment/deploy.sh PACKAGE_DIRECTORY TARGET_DIRECTORY\n' >&2
    exit 2
fi

if [ ! -d "$1" ] || [ ! -d "$2" ]; then
    printf 'Package and target must be existing directories.\n' >&2
    exit 2
fi

package=$(CDPATH= cd -- "$1" && pwd -P)
target=$(CDPATH= cd -- "$2" && pwd -P)
package_name=${package##*/}
package_parent=${package%/*}
case $package_name in
    ''|-*) printf 'Invalid package name: %s\n' "$package_name" >&2; exit 2 ;;
esac
[ -n "$package_parent" ] || package_parent=/

# Isolate Stow from user and working-directory .stowrc options, especially
# --adopt. Stow itself remains responsible for conflict detection and linking.
work=$(mktemp -d)
trap 'rm -rf -- "$work"' 0
cd -- "$work"
HOME=$work
export HOME

stow --simulate --no-folding --dir "$package_parent" --target "$target" --stow "$package_name"
stow --verbose=2 --no-folding --dir "$package_parent" --target "$target" --stow "$package_name"
