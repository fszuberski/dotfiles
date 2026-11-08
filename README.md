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
- `playbooks/zsh.yml` installs Zsh on the local Arch or macOS machine.
- `playbooks/nvim.yml` installs Neovim on the local Arch or macOS machine.
- `playbooks/nvim-config.yml` deploys the Neovim configuration with Stow.
- `playbooks/tmux.yml` installs tmux and its plugin manager.
- `playbooks/packages.yml` installs general-purpose development packages.
- `playbooks/fonts.yml` installs Meslo Nerd Font on Arch Linux or macOS.
- `playbooks/login-shell.yml` explicitly sets the local Arch user's login shell to Zsh.
- `legacy/` preserves the previous project as a reference; it is not part of the new deployment.
- `PLAN.md` tracks the incremental implementation.

The intended design separates shared configuration from platform and host overrides. Fleder and Kikimora will initially share an Arch/Sway profile, with room to diverge later. Configuration deployment, package installation, and privileged system changes will be separate operations.

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

To install Meslo Nerd Font:

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

Install Neovim with `ansible-playbook -i localhost, playbooks/nvim.yml --ask-become-pass` (omit `--ask-become-pass` on macOS). The playbook also installs `make` and `gcc` on Arch and builds the Telescope FZF extension if the plugin is already installed and its library is missing. On macOS, install Apple's command line developer tools separately if a compiler or `make` is missing. Deploy the copied configuration separately with `ansible-playbook -i localhost, playbooks/nvim-config.yml`. Stow stops on conflicts; it does not replace existing files. See `stow/nvim/.config/nvim/README.md` for its version and additional tooling requirements. Opening Neovim bootstraps and installs plugins; Ansible does not manage plugin installation. After plugins are downloaded, rerun the Neovim playbook if the FZF build needs repair.

Install general packages, including Node.js, npm, Go and unzip needed by some Mason language servers, with `ansible-playbook -i localhost, playbooks/packages.yml --ask-become-pass` (omit `--ask-become-pass` on macOS).

Deployment requires GNU Stow. It runs a simulation first and stops if that fails, uses `--no-folding`, and does not use `--adopt` or deliberately replace existing files. Stow's user and working-directory configuration files are not loaded by the wrapper. If a filesystem error or concurrent change occurs during linking, some links or directories may already have been created; inspect the target before retrying. This tool does not yet remove stale links.

To explicitly back up and replace one conflicting path, create a private backup directory outside the selected path and run:

```sh
sh deployment/replace.sh /path/to/package /path/to/home .zshrc /path/to/backups
```

The third argument is the selected path relative to the home directory; it must also exist in the package. The command prints the backup location, moves the original into that backup directory, and retries deployment. If another conflict prevents deployment, the selected original remains in the printed backup directory for manual recovery. Restore manually only after inspecting the target and avoiding overwriting newer changes. Do not put backups in the repository.

The planned deployment will stop on conflicts by default. Backing up and replacing existing files will require an explicit opt-in, with backups stored outside this repository and a documented restore procedure. Test changes on Fleder before deliberately applying them to Kikimora; validate macOS separately. Disk encryption, boot and mount configuration are outside the current scope.
