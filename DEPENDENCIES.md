# Dependencies

Configuration deployment currently needs a POSIX shell, `mktemp`, and GNU Stow. The test script also uses standard utilities such as `mkdir`, `cat`, and `rm`. It does not require Python or Ansible.

## Arch Linux (Fleder and Kikimora)

```sh
sudo pacman -S --needed stow
```

## macOS (Aethar)

Install [Homebrew](https://brew.sh/) first, then:

```sh
brew install stow
```

Ensure Homebrew's `bin` directory is on `PATH`. Package and system provisioning are not implemented yet; their dependencies will be documented when introduced.

Verify the installation with `stow --version`. Run the checks with `sh tests/deploy.sh`, `sh tests/backup.sh`, and `sh tests/replace.sh` from the repository root.

The copied Linux Zsh configuration requires Zsh, Oh My Zsh, Powerlevel10k, zsh-autosuggestions, the Arch nvm initialization script and Neovim. These are not installed by the deployment script yet. Run `sh tests/zsh.sh` to verify deployment; it also checks Zsh syntax when Zsh is installed.
