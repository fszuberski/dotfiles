#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
    printf 'Usage: sh deployment/backup.sh SOURCE BACKUP_DIRECTORY\n' >&2
    exit 2
fi
if [ ! -e "$1" ] && [ ! -L "$1" ]; then
    printf 'Source does not exist: %s\n' "$1" >&2
    exit 2
fi
if [ ! -d "$2" ]; then
    printf 'Backup directory does not exist: %s\n' "$2" >&2
    exit 2
fi

source_parent=$(CDPATH= cd -- "$(dirname -- "$1")" && pwd -P)
source_name=$(basename -- "$1")
case $source_name in
    /|.|..) printf 'Select a named source path.\n' >&2; exit 2 ;;
esac
source_path=$source_parent/$source_name
backup_root=$(CDPATH= cd -- "$2" && pwd -P)
if [ -d "$source_path" ] && [ ! -L "$source_path" ]; then
    source_directory=$(CDPATH= cd -- "$source_path" && pwd -P)
    case $backup_root/ in
        "$source_directory"/|"$source_directory"/*)
            printf 'Backup directory cannot be inside the source.\n' >&2
            exit 2
            ;;
    esac
fi

umask 077
backup=$(mktemp -d "$backup_root/backup.XXXXXXXX")
if ! cp -pR "$source_path" "$backup/item"; then
    printf 'Backup failed; inspect the partial backup at %s\n' "$backup" >&2
    exit 1
fi
printf '%s\n' "$backup"
