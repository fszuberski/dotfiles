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
- `stow/kanshi-fleder/` contains Fleder's display profile; other hosts do not deploy it.
- `stow/rofi/` contains the Tokyo Night Rofi configuration.
- `stow/swaync/` contains the Tokyo Night notification styling.
- `stow/networkmanager-dmenu/` configures the NetworkManager menu to use Rofi.
- `configuration/greetd/sway-config` is the separate Sway configuration intended for the graphical greeter.
- `stow/karabiner/` contains the existing macOS Karabiner configuration.
- `stow/macos-window-manager/` contains the existing yabai and skhd configurations.
- `playbooks/zsh.yml` installs Zsh on the local Arch or macOS machine.
- `playbooks/nvim.yml` installs Neovim on the local Arch or macOS machine.
- `playbooks/nvim-config.yml` deploys the Neovim configuration with Stow.
- `playbooks/tmux.yml` installs tmux and its plugin manager.
- `playbooks/packages.yml` installs general-purpose packages, including Arch build and Rofi Bluetooth dependencies.
- `playbooks/yay.yml` builds and installs Yay from its current AUR recipe on Arch.
- `playbooks/yay-update.yml` explicitly rebuilds and updates Yay from its current AUR recipe.
- `playbooks/yay-install-built.yml` explicitly installs a selected existing Yay package without changing its checkout.
- `playbooks/fonts.yml` installs Meslo Nerd Font and JetBrains Mono on Arch Linux or macOS.
- `playbooks/ghostty.yml` installs Ghostty on Arch Linux or macOS.
- `playbooks/sway.yml` installs Sway and its core Wayland dependencies on Arch Linux.
- `playbooks/waybar.yml` installs Waybar on Arch Linux.
- `playbooks/rofi.yml` installs Rofi on Arch Linux.
- `playbooks/swaync.yml` installs swaync and libnotify on Arch Linux.
- `playbooks/clipboard.yml` installs wl-clipboard and cliphist on Arch Linux.
- `playbooks/yazi.yml` installs the Yazi terminal file manager on Arch Linux.
- `playbooks/audio.yml` installs PipeWire audio tools on Arch Linux, stopping if the PulseAudio server is installed.
- `playbooks/brightness.yml` installs brightnessctl on Arch Linux.
- `playbooks/network.yml` installs NetworkManager and its Rofi-compatible menu without changing system services.
- `playbooks/polkit-agent.yml` installs a graphical polkit authentication agent on Arch Linux.
- `playbooks/bluetooth.yml` installs BlueZ and bluetoothctl; `playbooks/bluetooth-service.yml` enables and starts the Bluetooth system service.
- `playbooks/rofi-bluetooth.yml` installs the Rofi Bluetooth AUR menu through Yay.
- `playbooks/kanshi.yml` installs Kanshi for display profiles on Arch Linux.
- `playbooks/swaylock.yml` installs the swaylock screen locker on Arch Linux.
- `playbooks/swayidle.yml` installs the swayidle idle manager on Arch Linux.
- `playbooks/portals.yml` installs the desktop portal service and Wayland and GTK backends on Arch Linux.
- `playbooks/greeter.yml` installs greetd and ReGreet without enabling a graphical login service.
- `playbooks/greeter-test-config.yml` deploys an alternate greeter test configuration without replacing the active greetd configuration.
- `playbooks/rofi-bluetooth-install-built.yml` explicitly installs a selected existing Rofi Bluetooth package without changing its checkout.
- `playbooks/macos-window-manager.yml` installs yabai and skhd on macOS.
- `playbooks/macos-window-manager-config.yml` deploys their configuration with Stow.
- `playbooks/macos-window-manager-services.yml` starts their macOS user services.
- `playbooks/yabai-sudoers.yml` explicitly configures validated sudo access for yabai's scripting addition on macOS.
- `playbooks/login-shell.yml` explicitly sets the local Arch user's login shell to Zsh.
- `legacy/` preserves the previous project as a reference; it is not part of the new deployment.
- `PLAN.md` tracks the incremental implementation.

The intended design separates shared configuration from platform and host overrides. Fleder and Kikimora will initially share an Arch/Sway profile, with room to diverge later. Configuration deployment, package installation, and privileged system changes will be separate operations.

The Arch setup builds Yay from the current `master` branch of its AUR repository (the repository's default branch), cloning it to `~/code/yay` and building as the regular user. If Yay is already installed it skips the checkout and build; it does not update an installed Yay. Otherwise it checks the existing checkout's origin and branch, then **deletes recognized ignored build artifacts**, including `pkg/`, `src/` and Yay source and package archives, before fast-forwarding and rebuilding. It refuses to clean when other checkout changes are present. Do not keep personal files in those build paths. The recipe and upstream source can change between runs: inspect them before running the playbook, which builds third-party code without an interactive review pause.

To explicitly rebuild Yay from the latest AUR recipe, run `ansible-playbook -i localhost, playbooks/yay-update.yml --ask-become-pass`. This optional playbook is not part of the main setup and performs the same checkout safety checks and build-artifact cleanup.

If a trusted Yay package was already built but installation failed, explicitly select it with `ansible-playbook -i localhost, playbooks/yay-install-built.yml --ask-become-pass -e "yay_package_path=$HOME/code/yay/ACTUAL_PACKAGE_FILENAME"`. This installs the chosen file without modifying the checkout; inspect the package before selecting it.

## Shared Arch setup

After installing the prerequisites in `DEPENDENCIES.md`, run as the regular user:

```sh
ansible-playbook -i localhost, main.yml --ask-become-pass
```

This entry point checks all selected Stow packages for conflicts first, installs the configured packages and desktop applications, applies system changes including the Zsh login shell and Bluetooth service, then deploys the selected Stow configurations. Existing conflicting files are not replaced; resolve each explicitly before retrying. `--tags config` runs only the preflight and configuration deployment; `--tags install` runs only installation; `--tags system` runs the login-shell and Bluetooth service changes. OpenCode itself and tmux plugins are not installed by this playbook. Neovim installs its plugins on startup rather than through Ansible. macOS has separate playbooks and is not supported by this entry point yet.

The initial Sway configuration uses Super+Enter for Ghostty, Super+D for the Rofi launcher, Super+N for notifications, Super+Shift+Q to close a window, Super+Shift+C to reload and Super+Shift+E to exit. Install Waybar, Rofi and swaync and deploy their configurations before reloading Sway. Sway starts swaync at session startup, not on reload; avoid running another notification daemon simultaneously. Validate with `sway -C` and start a fresh Sway session from a TTY; keep another TTY available for recovery.

Sway starts clipboard history watchers for text and images at session startup. Press Super+Shift+V to select an item with Rofi. **Cliphist stores copied content on disk, potentially including passwords or other secrets.** Run `cliphist wipe` to delete the history; to disable collection, remove the two `wl-paste --watch` startup lines and restart the Sway session. This does not clear the current clipboard.

Press Super+Ctrl+E to open Yazi in Ghostty. Super+E remains the Sway layout toggle.

Install PipeWire audio tools with `ansible-playbook -i localhost, playbooks/audio.yml --ask-become-pass`. The playbook refuses to replace an installed PulseAudio server automatically; review any replacement and other package conflicts manually. PipeWire and WirePlumber normally run as user-session services.

Sway's audio and media keys control the default PipeWire devices and media player. Waybar displays volume and opens pavucontrol when clicked.

Brightness keys use brightnessctl's backlight class. External monitors may not expose a backlight device; check `brightnessctl --class=backlight --list`. DDC/CI monitor control is not configured.

Super+Shift+W opens the NetworkManager menu. NetworkManager must already be running; this playbook does not enable or start it. Sway starts a polkit agent for actions requiring graphical authentication; avoid starting another agent in the same session. `nmtui` is a terminal fallback.

The main setup deploys a Kanshi profile only when the hostname is `fleder`. It matches DP-1 at 2560×1440, 99.946 Hz, position 0,0 and scale 1. Sway starts Kanshi at session startup only if `~/.config/kanshi/config` exists; otherwise Sway handles displays normally. For a different monitor or connector, update the host profile after inspecting `swaymsg -t get_outputs`. Unmatched configurations are left to Sway. Test display changes with a recovery TTY available.

### Updating Fleder's display profile

The current DP-1 profile reflects the monitor temporarily connected to Fleder; it is not a profile for the future 4K TV or for Kikimora.

1. Connect the new display and, in Fleder's Sway session, run `swaymsg -t get_outputs`. Note the connector name, supported mode and refresh rate. If `swaymsg` reports a stale socket, update the current shell with `export SWAYSOCK="$(systemctl --user show-environment | sed -n 's/^SWAYSOCK=//p')"` and retry.
2. Edit `stow/kanshi-fleder/.config/kanshi/config` in this repository. For example, **only if the TV reports this connector and mode**:

   ```conf
   profile fleder {
       output HDMI-A-1 enable mode 3840x2160@60Hz position 0,0 scale 1
   }
   ```

   Use an exact supported mode and adjust the position or scale as needed. Sway reports refresh rates in millihertz; for example, `59940` means `59.94Hz`.
3. If the package isn't linked yet, deploy it with `ansible-playbook -i localhost, main.yml --tags config`. With the Stow link in place, later repository edits are immediately visible to Kanshi. Run `kanshictl reload` from the graphical session, then check `kanshictl status` and `swaymsg -t get_outputs`. Keep a recovery TTY available when testing changes.

Kanshi starts on a fresh Sway session when its config exists; a Sway reload alone does not start it. Kikimora will need a separate host-specific profile and deployment selection.

### Screen locking

Super+Shift+Escape manually locks the screen with swaylock. Install swaylock and test locking and unlocking with your regular login password before relying on it. Keep a recovery TTY available. In a fresh Sway session, swayidle locks after five minutes of inactivity, turns displays off after ten minutes and turns them back on with activity; it also locks before sleep. It does not suspend automatically. Verify the idle and suspend behavior on the machine before relying on it.

The Sway desktop portals support application integration such as screen sharing and file choosers. Arch's Sway configuration imports the graphical session environment; the portals normally start on demand. After a fresh session, check `systemctl --user show-environment | grep -E '^(WAYLAND_DISPLAY|XDG_CURRENT_DESKTOP)='`, then test a file chooser and screen sharing. If they fail, inspect `systemctl --user status xdg-desktop-portal` and `journalctl --user -b | grep -i portal`.

The Arch setup installs greetd and ReGreet for a future graphical login. To prepare the separate test configuration, run `ansible-playbook -i localhost, playbooks/greeter-test-config.yml --ask-become-pass`. It installs `/etc/greetd/dotfiles-test-config.toml` and `/etc/greetd/dotfiles-sway-config`, refusing to replace differing files or symlinks. It does not alter `/etc/greetd/config.toml`, start greetd or enable a service. Continue starting Sway from a TTY until the greeter is tested and enabled.

The main Arch setup installs BlueZ, enables and starts `bluetooth.service`, and installs the `rofi-bluetooth-git` AUR package through Yay. Super+Shift+B opens its menu; `bluetoothctl` is a terminal fallback. Yay builds locally as the regular user using the current, unpinned PKGBUILD and upstream Git source, and runs third-party code without an interactive review pause. Review both before running the playbook. Run `playbooks/packages.yml` first when invoking the Rofi Bluetooth playbook separately; it installs `python-pexpect` and the other official dependencies. The Rofi Bluetooth playbook prompts separately for the sudo password Yay requests; Yay's task output is hidden to protect the password. Yay uses its own build cache; an existing `~/code/rofi-bluetooth-git` checkout is not modified. The playbook skips updates if the package is installed. The `system` tag also runs Bluetooth service setup.

To install a trusted already-built Rofi Bluetooth package without modifying its checkout, run `ansible-playbook -i localhost, playbooks/rofi-bluetooth-install-built.yml --ask-become-pass -e "rofi_bluetooth_package_path=$HOME/code/rofi-bluetooth-git/ACTUAL_PACKAGE_FILENAME"`.

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
