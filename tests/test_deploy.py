import tempfile
import unittest
import subprocess
from pathlib import Path
from unittest.mock import patch
import shutil

from deployment.deploy import DeploymentConflict, deploy


class DeployTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        root = Path(self.tmp.name)
        self.package = root / "package"
        self.home = root / "home"
        self.package.mkdir()
        self.home.mkdir()

    @unittest.skipUnless(shutil.which("stow"), "GNU Stow is not installed")
    def test_links_files_and_can_be_repeated(self):
        source = self.package / ".config" / "app" / "config"
        source.parent.mkdir(parents=True)
        source.write_text("configuration")
        deploy(self.package, self.home)
        target = self.home / ".config" / "app" / "config"
        self.assertTrue(target.is_symlink())
        self.assertEqual(target.resolve(), source)
        deploy(self.package, self.home)
        self.assertEqual(target.read_text(), "configuration")

    def test_conflict_stops_before_creating_any_links(self):
        (self.package / ".a").write_text("new")
        (self.package / ".z").write_text("new")
        target = self.home / ".z"
        target.write_text("existing")
        with self.assertRaises(DeploymentConflict):
            deploy(self.package, self.home)
        self.assertFalse((self.home / ".a").exists())
        self.assertEqual(target.read_text(), "existing")

    def test_symlinked_parent_is_not_followed(self):
        source = self.package / ".config" / "app"
        source.mkdir(parents=True)
        (source / "config").write_text("new")
        elsewhere = Path(self.tmp.name) / "elsewhere"
        elsewhere.mkdir()
        (self.home / ".config").symlink_to(elsewhere)
        with self.assertRaises(DeploymentConflict):
            deploy(self.package, self.home)
        self.assertEqual(list(elsewhere.iterdir()), [])

    @patch("deployment.deploy.subprocess.run")
    def test_uses_stow_simulation_before_linking(self, run):
        (self.package / ".zshrc").write_text("new")
        deploy(self.package, self.home)
        self.assertEqual(run.call_count, 2)
        first = run.call_args_list[0].args[0]
        second = run.call_args_list[1].args[0]
        self.assertEqual(first[0], "stow")
        self.assertIn("--simulate", first)
        self.assertNotIn("--simulate", second)
        self.assertIn("--no-folding", second)
        self.assertEqual(second[-1], "package")

    @patch("deployment.deploy.subprocess.run")
    def test_failed_stow_simulation_prevents_linking(self, run):
        run.side_effect = subprocess.CalledProcessError(1, "stow")
        with self.assertRaises(subprocess.CalledProcessError):
            deploy(self.package, self.home)
        self.assertEqual(run.call_count, 1)


if __name__ == "__main__":
    unittest.main()
