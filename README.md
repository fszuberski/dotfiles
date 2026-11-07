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
- `legacy/` preserves the previous project as a reference; it is not part of the new deployment.
- `PLAN.md` tracks the incremental implementation.

The intended design separates shared configuration from platform and host overrides. Fleder and Kikimora will initially share an Arch/Sway profile, with room to diverge later. Configuration deployment, package installation, and privileged system changes will be separate operations.

## Status and safety

The new deployment system is in early development. Do not run the legacy playbooks as a substitute: they have not been adapted to their new paths and may overwrite existing configuration or change system settings.

To link a single package using GNU Stow:

```sh
sh deployment/deploy.sh /path/to/package /path/to/home
```

For example, from the repository root, `sh deployment/deploy.sh stow/zsh "$HOME"` deploys the shared Zsh configuration. It sets Neovim as the editor, aliases `vim` to `nvim`, and enables Zsh's built-in history and completion; install Neovim separately. Prompt, plugins and machine-specific settings have not yet been configured.

Deployment requires GNU Stow. It runs a simulation first and stops if that fails, uses `--no-folding`, and does not use `--adopt` or deliberately replace existing files. Stow's user and working-directory configuration files are not loaded by the wrapper. If a filesystem error or concurrent change occurs during linking, some links or directories may already have been created; inspect the target before retrying. This tool does not yet remove stale links.

To explicitly back up and replace one conflicting path, create a private backup directory outside the selected path and run:

```sh
sh deployment/replace.sh /path/to/package /path/to/home .zshrc /path/to/backups
```

The third argument is the selected path relative to the home directory; it must also exist in the package. The command prints the backup location, moves the original into that backup directory, and retries deployment. If another conflict prevents deployment, the selected original remains in the printed backup directory for manual recovery. Restore manually only after inspecting the target and avoiding overwriting newer changes. Do not put backups in the repository.

The planned deployment will stop on conflicts by default. Backing up and replacing existing files will require an explicit opt-in, with backups stored outside this repository and a documented restore procedure. Test changes on Fleder before deliberately applying them to Kikimora; validate macOS separately. Disk encryption, boot and mount configuration are outside the current scope.
