#!/usr/bin/env python
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Updates the config files without destroying anything."""

import os
import shutil
import subprocess
from maruel import *


def update_config(config_dir):
  home_dir = os.path.expanduser('~')
  basefilename = os.path.basename(__file__)
  existing = []
  for basename in os.listdir(config_dir):
    src = os.path.join(config_dir, basename)
    dst = os.path.join(home_dir, basename)
    if os.path.isdir(src):
      # TODO(maruel): !!
      continue
    if basename in (basefilename, 'README'):
      continue
    if not os.path.exists(dst):
      print('Copying %s' % basename)
      shutil.copyfile(src, dst)
    else:
      existing.append((basename, src, dst))

  for basename, src, dst in existing:
    if read(src) != read(dst):
      # Diff. Note that diff will return 1 when there's a diff.
      print('Diffing %s' % basename)
      subprocess.call(['diff', src, dst])


def main():
  curpath = os.path.dirname(os.path.abspath(__file__))
  update_config(os.path.join(curpath, 'configs'))


if __name__ == '__main__':
  main()
