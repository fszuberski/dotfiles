import tempfile
import unittest
from pathlib import Path

from deployment.preflight import find_conflicts


class PreflightTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        root = Path(self.tmp.name)
        self.package = root / "package"
        self.home = root / "home"
        self.package.mkdir()
        self.home.mkdir()

    def test_fresh_and_correct_link_have_no_conflicts(self):
        source = self.package / ".zshrc"
        source.write_text("new")
        self.assertEqual(find_conflicts(self.package, self.home), [])
        (self.home / ".zshrc").symlink_to(source)
        self.assertEqual(find_conflicts(self.package, self.home), [])

    def test_existing_file_is_reported_and_untouched(self):
        (self.package / ".zshrc").write_text("new")
        target = self.home / ".zshrc"
        target.write_text("existing")
        self.assertEqual(find_conflicts(self.package, self.home), [target])
        self.assertEqual(target.read_text(), "existing")

    def test_existing_parent_symlink_is_a_conflict(self):
        (self.package / ".config" / "app").mkdir(parents=True)
        (self.package / ".config" / "app" / "config").write_text("new")
        target = self.home / ".config"
        target.symlink_to(self.package / ".config", target_is_directory=True)
        self.assertEqual(find_conflicts(self.package, self.home), [target])

    def test_broken_symlink_is_a_conflict(self):
        (self.package / ".zshrc").write_text("new")
        target = self.home / ".zshrc"
        target.symlink_to(self.home / "missing")
        self.assertEqual(find_conflicts(self.package, self.home), [target])


if __name__ == "__main__":
    unittest.main()
