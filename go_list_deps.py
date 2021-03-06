#!/usr/bin/python
# Copyright 2018 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""List tree of dependencies."""

import subprocess
import sys


def get_imports(pkg):
  return subprocess.check_output(
      ['go', 'list', '-f', '{{join .Imports "\\n"}}', pkg]).splitlines()


def recurse(pkg, seen, indent):
  print('%s%s' % (' ' * indent, pkg))
  for i in get_imports(pkg):
    if i in seen:
      # Print it but don't recurse.
      print('%s%s*' % (' ' * (indent+2), i))
      continue
    seen.add(i)
    recurse(i, seen, indent+2)


def main(args):
  if not args:
    args = ['.']
  if len(args) != 1:
    print >> sys.stderr, 'Only one package at a time'
    return 1
  pkg = args[0]
  if pkg == '.':
    pkg = subprocess.check_output(
        ['go', 'list', '-f', '{{.ImportPath}}', pkg]).strip()
  if pkg.startswith('./'):
    print >> sys.stderr, './ format is not yet supported'
    return 1
  recurse(pkg, set(), 0)
  return 0


if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
