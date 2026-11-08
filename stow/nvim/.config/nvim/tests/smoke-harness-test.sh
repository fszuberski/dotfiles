#!/bin/sh
set -eu

test_dir=$(mktemp -d "${TMPDIR:-/tmp}/nvim-smoke-test.XXXXXXXX")
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM
mkdir -p "$test_dir/good" "$test_dir/bad" "$test_dir/bootstrap" "$test_dir/bootstrap-error"
printf '%s\n' 'vim.g.smoke_fixture_loaded = true' > "$test_dir/good/init.lua"
printf '%s\n' 'error("intentional startup failure")' > "$test_dir/bad/init.lua"
ln -s "$test_dir/bad" "$test_dir/bad-link"
cat > "$test_dir/bootstrap/init.lua" <<'EOF'
local marker = vim.fn.stdpath("data") .. "/bootstrapped"
if vim.fn.filereadable(marker) == 0 then
    vim.fn.mkdir(vim.fn.stdpath("data"), "p")
    vim.fn.writefile({}, marker)
    print("Installing plugins...")
end
EOF
cat > "$test_dir/bootstrap-error/init.lua" <<'EOF'
local marker = vim.fn.stdpath("data") .. "/bootstrapped"
if vim.fn.filereadable(marker) == 0 then
    vim.fn.mkdir(vim.fn.stdpath("data"), "p")
    vim.fn.writefile({}, marker)
    error("first-run failure")
end
EOF

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$test_dir/good"
sh "$script_dir/smoke.sh" "$test_dir/bootstrap"
if sh "$script_dir/smoke.sh" "$test_dir/bootstrap-error"; then
    echo 'Smoke test did not detect a first-run error' >&2
    exit 1
fi
if sh "$script_dir/smoke.sh" "$test_dir/bad"; then
    echo 'Smoke test did not detect a startup error' >&2
    exit 1
fi
if sh "$script_dir/smoke.sh" "$test_dir/bad-link"; then
    echo 'Smoke test did not detect a startup error through a symlink' >&2
    exit 1
fi
echo 'Smoke harness checks passed'
