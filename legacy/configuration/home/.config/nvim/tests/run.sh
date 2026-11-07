#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$script_dir/.."

unit_tests() {
    for test in "$script_dir"/*-test.lua; do
        case "$test" in
            */lazy-bootstrap-test.lua) continue ;;
        esac
        printf 'Running %s\n' "${test##*/}"
        nvim --headless -u NONE -i NONE -l "$test"
    done
    sh "$script_dir/lazy-bootstrap-test.sh"
    sh "$script_dir/smoke-harness-test.sh"
}

startup_test() {
    sh "$script_dir/smoke.sh"
}

case "${1:-quick}" in
    unit) unit_tests ;;
    smoke) startup_test ;;
    quick) unit_tests; startup_test ;;
    all)
        unit_tests
        startup_test
        for test in "$script_dir"/*-smoke.sh; do
            printf 'Running %s\n' "${test##*/}"
            sh "$test"
        done
        ;;
    *)
        echo "Usage: sh tests/run.sh [unit|smoke|quick|all]" >&2
        exit 2
        ;;
esac
