#! /usr/bin/env python
import os

dotfiles_dir = os.path.join(os.environ['HOME'], '.dotfiles')
for filename in os.listdir(dotfiles_dir):
    if filename in [".git", "script.py"]:
        continue
    symlinkpath = os.path.join(os.environ['HOME'], filename)
    if os.path.isfile(symlinkpath):
        os.unlink(symlinkpath)
    os.symlink(os.path.join(dotfiles_dir, filename), symlinkpath)
