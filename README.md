# Dotfiles

Configuration and provisioning for three personal machines:

| Host | Platform | Purpose |
| --- | --- | --- |
| `fleder` | Arch Linux | Secondary PC and first test machine for Sway/Wayland |
| `kikimora` | Arch Linux | Main PC; initially shares Fleder's setup |
| `aethar` | macOS, Apple Silicon | M1 MacBook Pro |

## Layout

- `inventory/hosts.yml` defines the supported hosts and platform groups.
- `legacy/` preserves the previous project as a reference; it is not part of the new deployment.
- `PLAN.md` tracks the incremental implementation.

The intended design separates shared configuration from platform and host overrides. Fleder and Kikimora will initially share an Arch/Sway profile, with room to diverge later. Configuration deployment, package installation, and privileged system changes will be separate operations.

## Status and safety

The new deployment system is not implemented yet. Do not run the legacy playbooks as a substitute: they have not been adapted to their new paths and may overwrite existing configuration or change system settings.

An initial read-only preflight can check a single package against an existing target directory, without creating or replacing files:

```sh
python3 -m deployment.preflight /path/to/package /path/to/home
python3 -m unittest discover -s tests -v
```

The preflight lists conflicts and exits with status 1 if any are found. It treats symlinked target directories as conflicts and does not yet deploy anything.

The planned deployment will stop on conflicts by default. Backing up and replacing existing files will require an explicit opt-in, with backups stored outside this repository and a documented restore procedure. Test changes on Fleder before deliberately applying them to Kikimora; validate macOS separately. Disk encryption, boot and mount configuration are outside the current scope.
