#!/usr/bin/env python3
# Copyright 2024 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Rebuilds all outdated go executables."""

import argparse
import glob
import os
import subprocess
import sys


def output(cmd):
  return subprocess.check_output(cmd).decode('utf-8').strip()


def main():
  parser = argparse.ArgumentParser(description=sys.modules[__name__].__doc__)
  parser.add_argument("--dry-run", action="store_true")
  parser.add_argument("files", nargs='*')
  args = parser.parse_args()
  args.files = args.files or sorted(glob.glob(os.path.join(output(["go", "env", "GOBIN"]), "*")))
  width = max(len(f) for f in args.files)
  goversion = output(["go", "version"]).split()[2]
  for f in args.files:
    lines = output(["go", "version", "-m", f]).splitlines()
    version = lines[0].split()[1]
    props = {p[0]: p[1:] for p in (l.strip().split() for l in lines[1:])}
    path = props["path"][0]
    if goversion != version:
      print(f"{f: <{width}}: {version:8} => {goversion:8}  {path}")
    else:
      print(f"{f: <{width}}: {version:8}              {path}")
      continue
    if not args.dry_run:
      subprocess.check_call(["go", "install", path + "@latest"])
  return 0


if __name__ == "__main__":
  sys.exit(main())
