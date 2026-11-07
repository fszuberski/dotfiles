# Dependencies

Configuration deployment needs a POSIX shell, `mktemp`, and GNU Stow. Its test scripts also use standard utilities such as `mkdir`, `cat`, and `rm`. Deployment itself does not require Python or Ansible.

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

## Ansible provisioning

The Zsh installation playbook additionally requires Ansible and the `community.general` collection. On Arch install `ansible-core` with pacman; on macOS install `ansible` with Homebrew. Then, from the repository root:

```sh
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i localhost, playbooks/zsh.yml --syntax-check
```

Run `sh tests/ansible-zsh.sh` for the playbook checks. Installing Zsh on Arch requires sudo privileges; Homebrew must already be installed and configured on macOS.

The copied Linux Zsh configuration also expects Oh My Zsh, Powerlevel10k, zsh-autosuggestions, the Arch nvm initialization script and Neovim. The Zsh installation playbook does not install those dependencies. Run `sh tests/zsh.sh` to verify configuration deployment; it also checks Zsh syntax when Zsh is installed.
