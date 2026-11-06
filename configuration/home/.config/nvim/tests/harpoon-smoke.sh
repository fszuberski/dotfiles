#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua assert(require("harpoon").get_menu_config().width > 0, "Harpoon menu width must be positive"); require("harpoon.ui").toggle_quick_menu(); assert(Harpoon_win_id and vim.api.nvim_win_is_valid(Harpoon_win_id), "Harpoon menu did not open")'
