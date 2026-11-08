# Dotfiles

Configuration and provisioning for three personal machines:

| Host | Platform | Purpose |
| --- | --- | --- |
| `fleder` | Arch Linux | Secondary PC and first test machine for Sway/Wayland |
| `kikimora` | Arch Linux | Main PC; initially shares Fleder's setup |
| `aethar` | macOS, Apple Silicon | M1 MacBook Pro |

## Layout

- `inventory/hosts.yml` defines the supported hosts and platform groups.
- `DEPENDENCIES.md` lists prerequisites and installation commands.
- `stow/zsh/` contains the initial shared Zsh configuration.
- `stow/nvim/` contains the existing Neovim configuration, its lockfile and tests.
- `stow/tmux/` contains the existing shared tmux configuration.
- `stow/git/` contains the existing Linux Git configuration.
- `stow/opencode/` contains OpenCode CLI settings and workflow instructions, not private service configuration.
- `stow/ghostty/` contains the Ghostty configuration copied from macOS.
- `stow/sway/` contains the shared Arch Sway configuration.
- `stow/waybar/` contains the Tokyo Night Waybar configuration.
- `stow/rofi/` contains the Tokyo Night Rofi configuration.
- `stow/swaync/` contains the Tokyo Night notification styling.
- `stow/karabiner/` contains the existing macOS Karabiner configuration.
- `stow/macos-window-manager/` contains the existing yabai and skhd configurations.
- `playbooks/zsh.yml` installs Zsh on the local Arch or macOS machine.
- `playbooks/nvim.yml` installs Neovim on the local Arch or macOS machine.
- `playbooks/nvim-config.yml` deploys the Neovim configuration with Stow.
- `playbooks/tmux.yml` installs tmux and its plugin manager.
- `playbooks/packages.yml` installs general-purpose development packages.
- `playbooks/fonts.yml` installs Meslo Nerd Font and JetBrains Mono on Arch Linux or macOS.
- `playbooks/ghostty.yml` installs Ghostty on Arch Linux or macOS.
- `playbooks/sway.yml` installs Sway and its core Wayland dependencies on Arch Linux.
- `playbooks/waybar.yml` installs Waybar on Arch Linux.
- `playbooks/rofi.yml` installs Rofi on Arch Linux.
- `playbooks/swaync.yml` installs swaync and libnotify on Arch Linux.
- `playbooks/clipboard.yml` installs wl-clipboard and cliphist on Arch Linux.
- `playbooks/yazi.yml` installs the Yazi terminal file manager on Arch Linux.
- `playbooks/macos-window-manager.yml` installs yabai and skhd on macOS.
- `playbooks/macos-window-manager-config.yml` deploys their configuration with Stow.
- `playbooks/macos-window-manager-services.yml` starts their macOS user services.
- `playbooks/yabai-sudoers.yml` explicitly configures validated sudo access for yabai's scripting addition on macOS.
- `playbooks/login-shell.yml` explicitly sets the local Arch user's login shell to Zsh.
- `legacy/` preserves the previous project as a reference; it is not part of the new deployment.
- `PLAN.md` tracks the incremental implementation.

The intended design separates shared configuration from platform and host overrides. Fleder and Kikimora will initially share an Arch/Sway profile, with room to diverge later. Configuration deployment, package installation, and privileged system changes will be separate operations.

## Shared Arch setup

After installing the prerequisites in `DEPENDENCIES.md`, run as the regular user:

```sh
ansible-playbook -i localhost, main.yml --ask-become-pass
```

This entry point checks all selected Stow packages for conflicts first, installs the current general packages, Zsh, fonts, tmux, Neovim, Ghostty, core Sway packages, Waybar, Rofi and swaync, sets Zsh as the login shell, then deploys Zsh, tmux, Git, Neovim, Ghostty, OpenCode, Sway, Waybar, Rofi and swaync configuration. Existing conflicting files are not replaced; resolve each explicitly before retrying. `--tags config` runs only the preflight and configuration deployment; `--tags install` runs only installation; `--tags system` runs only the login-shell change. OpenCode itself and tmux plugins are not installed by this playbook. Neovim installs its plugins on startup rather than through Ansible. Other desktop applications are not yet included. macOS has separate playbooks and is not supported by this entry point yet.

The initial Sway configuration uses Super+Enter for Ghostty, Super+D for the Rofi launcher, Super+N for notifications, Super+Shift+Q to close a window, Super+Shift+C to reload and Super+Shift+E to exit. Install Waybar, Rofi and swaync and deploy their configurations before reloading Sway. Sway starts swaync at session startup, not on reload; avoid running another notification daemon simultaneously. Validate with `sway -C` and start a fresh Sway session from a TTY; keep another TTY available for recovery.

Sway starts clipboard history watchers for text and images at session startup. Press Super+Shift+V to select an item with Rofi. **Cliphist stores copied content on disk, potentially including passwords or other secrets.** Run `cliphist wipe` to delete the history; to disable collection, remove the two `wl-paste --watch` startup lines and restart the Sway session. This does not clear the current clipboard.

Press Super+Ctrl+E to open Yazi in Ghostty. Super+E remains the Sway layout toggle.

To install Zsh after setting up the Ansible dependencies in `DEPENDENCIES.md`:

```sh
ansible-playbook -i localhost, playbooks/zsh.yml --ask-become-pass
```

The playbook installs Zsh and clones Oh My Zsh, Powerlevel10k and zsh-autosuggestions if they are not already present. It does not update existing checkouts, change the login shell or deploy configuration. `--ask-become-pass` is needed when sudo on Arch requires a password; omit it on macOS.

To explicitly make Zsh the current user's login shell on Arch Linux, run as that regular user:

```sh
ansible-playbook -i localhost, playbooks/login-shell.yml --ask-become-pass
```

The change applies to new login sessions. This separate playbook does not support macOS yet.

To install Meslo Nerd Font and JetBrains Mono:

```sh
ansible-playbook -i localhost, playbooks/fonts.yml --ask-become-pass
```

Omit `--ask-become-pass` on macOS. If icons do not appear automatically, configure the terminal to use an installed Meslo Nerd Font family.

## Status and safety

The new deployment system is in early development. Do not run the legacy playbooks as a substitute: they have not been adapted to their new paths and may overwrite existing configuration or change system settings.

To link a single package using GNU Stow:

```sh
sh deployment/deploy.sh /path/to/package /path/to/home
```

For example, from the repository root, `sh deployment/deploy.sh stow/zsh "$HOME"` deploys the Linux Zsh and Powerlevel10k settings copied from `legacy/`. They expect Oh My Zsh, Powerlevel10k and zsh-autosuggestions. nvm is loaded if present at its Arch or Apple Silicon Homebrew location. Review the configuration before deploying it, especially on macOS.

Install tmux and its plugin manager (TPM) with `ansible-playbook -i localhost, playbooks/tmux.yml --ask-become-pass` (omit `--ask-become-pass` on macOS). The playbook does not update an existing TPM checkout or deploy configuration. Deploy the existing configuration separately with `sh deployment/deploy.sh stow/tmux "$HOME"`. Inside tmux, press `Ctrl-a` followed by uppercase `I` to install its configured plugins.

Deploy the copied Git configuration with `sh deployment/deploy.sh stow/git "$HOME"`. It expects Neovim and the `delta` pager; Delta is installed by `playbooks/packages.yml`. The Linux configuration enables Delta's side-by-side view; the old macOS configuration did not.

The OpenCode package contains the V2 CLI settings and global workflow instructions. Deploy it with `sh deployment/deploy.sh stow/opencode "$HOME"`; existing files will be reported as conflicts. Private OpenCode service configuration is intentionally excluded and must remain machine-local.

Install Ghostty with `ansible-playbook -i localhost, playbooks/ghostty.yml --ask-become-pass` (omit `--ask-become-pass` on macOS). Deploy its configuration separately with `sh deployment/deploy.sh stow/ghostty "$HOME"`. The configuration was tested on macOS; its Linux behavior still needs verification. It selects JetBrains Mono, which is installed by `playbooks/fonts.yml`, and contains macOS-specific settings.

On macOS, deploy the copied Karabiner configuration with `sh deployment/deploy.sh stow/karabiner "$HOME"`. Automatic backup snapshots remain in `legacy/` and are not deployed. Karabiner may modify its configuration; review changes in the repository after editing settings through the application.

Install yabai and skhd on macOS with `ansible-playbook -i localhost, playbooks/macos-window-manager.yml`. Deploy their configuration separately with `ansible-playbook -i localhost, playbooks/macos-window-manager-config.yml`; it stops on existing-file conflicts. The configuration has not been validated on Aethar. Review it first: the yabai configuration invokes `sudo` to load its scripting addition, the skhd terminal shortcut points to Kitty, and the retained `fn-f` topmost command needs verification against the installed yabai version.

For the optional yabai scripting addition, run `ansible-playbook -i localhost, playbooks/yabai-sudoers.yml --ask-become-pass` as the regular macOS user. It manages only `/private/etc/sudoers.d/dotfiles-yabai`, validates the file with `visudo`, and pins access to the installed binary's SHA-256 digest. It refuses to overwrite an unmanaged file at that path; review any separate pre-existing yabai sudoers rules manually. Rerun the playbook after updating yabai to refresh its digest. The scripting addition requires partially disabled System Integrity Protection; the playbooks do not change SIP.

After installing the applications, deploying their configurations and setting up the sudoers rule, start the services with `ansible-playbook -i localhost, playbooks/macos-window-manager-services.yml` from the regular user's graphical macOS login session. The playbook uses the applications' native service commands and checks launchd; it does not change SIP. macOS may require manually granting Accessibility permissions. Review any existing Homebrew-managed or older yabai/skhd services before running it to avoid duplicate services. These steps have not yet been validated on Aethar.

Install Neovim with `ansible-playbook -i localhost, playbooks/nvim.yml --ask-become-pass` (omit `--ask-become-pass` on macOS). The playbook also installs `make` and `gcc` on Arch and builds the Telescope FZF extension if the plugin is already installed and its library is missing. On macOS, install Apple's command line developer tools separately if a compiler or `make` is missing. Deploy the copied configuration separately with `ansible-playbook -i localhost, playbooks/nvim-config.yml`. Stow stops on conflicts; it does not replace existing files. See `stow/nvim/.config/nvim/README.md` for its version and additional tooling requirements. Opening Neovim bootstraps and installs plugins; Ansible does not manage plugin installation. After plugins are downloaded, rerun the Neovim playbook if the FZF build needs repair.

Install general packages, including Node.js, npm, Go and unzip needed by some Mason language servers, with `ansible-playbook -i localhost, playbooks/packages.yml --ask-become-pass` (omit `--ask-become-pass` on macOS).

Deployment requires GNU Stow. It runs a simulation first and stops if that fails, uses `--no-folding`, and does not use `--adopt` or deliberately replace existing files. Stow's user and working-directory configuration files are not loaded by the wrapper. If a filesystem error or concurrent change occurs during linking, some links or directories may already have been created; inspect the target before retrying. This tool does not yet remove stale links.

To explicitly back up and replace one conflicting path, create a private backup directory outside the selected path and run:

```sh
sh deployment/replace.sh /path/to/package /path/to/home .zshrc /path/to/backups
```

The third argument is the selected path relative to the home directory; it must also exist in the package. The command prints the backup location, moves the original into that backup directory, and retries deployment. If another conflict prevents deployment, the selected original remains in the printed backup directory for manual recovery. Restore manually only after inspecting the target and avoiding overwriting newer changes. Do not put backups in the repository.

The planned deployment will stop on conflicts by default. Backing up and replacing existing files will require an explicit opt-in, with backups stored outside this repository and a documented restore procedure. Test changes on Fleder before deliberately applying them to Kikimora; validate macOS separately. Disk encryption, boot and mount configuration are outside the current scope.
