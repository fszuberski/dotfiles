"""Safely invoke GNU Stow for a single configuration package."""

import argparse
import os
import subprocess
import tempfile
from pathlib import Path

from deployment.preflight import find_conflicts


class DeploymentConflict(Exception):
    """An existing target prevents safe deployment."""


def deploy(package: Path, home: Path) -> None:
    package = package.absolute()
    home = home.absolute()
    conflicts = find_conflicts(package, home)
    if conflicts:
        raise DeploymentConflict("Conflicting paths:\n" + "\n".join(map(str, conflicts)))

    command = [
        "stow", "--dir", str(package.parent), "--target", str(home),
        "--no-folding", "--stow", "--", package.name,
    ]
    # Avoid implicit ~/.stowrc or working-directory .stowrc options, notably
    # --adopt, which could otherwise modify files in the package.
    with tempfile.TemporaryDirectory(prefix="dotfiles-stow-") as directory:
        env = {**os.environ, "HOME": directory}
        subprocess.run(command[:1] + ["--simulate"] + command[1:],
                       check=True, cwd=directory, env=env)
        subprocess.run(command, check=True, cwd=directory, env=env)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("package", type=Path, help="configuration package directory")
    parser.add_argument("home", type=Path, help="target home directory")
    args = parser.parse_args()
    try:
        deploy(args.package, args.home)
    except (DeploymentConflict, ValueError, OSError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"Deployment stopped: {error}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
