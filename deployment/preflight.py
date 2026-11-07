"""Read-only conflict checks for a home-directory configuration package."""

import argparse
from pathlib import Path


def find_conflicts(package: Path, home: Path) -> list[Path]:
    """Return target paths that cannot be linked without replacing something."""
    if not package.is_dir() or not home.is_dir():
        raise ValueError("package and home must be existing directories")

    conflicts = []

    def visit(source: Path, target: Path) -> None:
        if source.is_dir() and not source.is_symlink():
            if target.is_symlink() or (target.exists() and not target.is_dir()):
                conflicts.append(target)
                return
            for child in sorted(source.iterdir()):
                visit(child, target / child.name)
        elif target.is_symlink():
            if target.resolve() != source.resolve():
                conflicts.append(target)
        elif target.exists():
            conflicts.append(target)

    for child in sorted(package.iterdir()):
        visit(child, home / child.name)
    return conflicts


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("package", type=Path, help="configuration package directory")
    parser.add_argument("home", type=Path, help="target home directory")
    args = parser.parse_args()
    try:
        conflicts = find_conflicts(args.package, args.home)
    except ValueError as error:
        parser.error(str(error))
    for conflict in conflicts:
        print(conflict)
    return 1 if conflicts else 0


if __name__ == "__main__":
    raise SystemExit(main())
