#!/usr/bin/env python
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Generates a diff to apply to /usr/share/polkit-1/actions to fix using gnome
administrative applications from a NX (nomachine) session.

NX sessions are considered 'inactive'.

Example usage:
cd /usr/share/polkit-1/actions
fix_inactive_policy.py | patch --dry-run

If it succeeds, then you can run:
fix_inactive_policy.py | sudo patch --backup --no-backup-if-mismatch
sudo pkill polkitd

You can restore with:
for i in *.orig; do sudo mv "$i" "${i/.orig}"; done
"""

from __future__ import with_statement
import difflib
import os
import re
import sys


def main():
  out = fix_inactive_deny('/usr/share/polkit-1/actions/')
  for filename, original, new in out:
    print ''.join(difflib.unified_diff(original, new, filename, filename))
  return 0


def fix_inactive_deny(path):
  """Crude way to modified policies.

  In theory it'd be better to use xml.etree but there is no way to keep the
  original formatting.
  """
  out = []
  filenames = os.listdir(path)
  if any(f.endswith('.orig') for f in filenames):
    print >> sys.stderr, "Found backup files, aborting!"
    return out

  re_active = re.compile(r'<allow_active>(.+?)</allow_active>')
  for filename in filenames:
    filepath = os.path.join(path, filename)
    with open(filepath) as f:
      lines = f.read().splitlines(True)

    original = lines[:]
    for index, line in enumerate(lines):
      if re.search(r'<allow_any>no</allow_any>', line):
        m = re_active.search(lines[index + 1])
        if not m:
          m = re_active.search(lines[index + 2])
        lines[index] = line.replace(
            '<allow_any>no</allow_any>',
            '<allow_any>%s</allow_any>' %
               m.group(1).encode('ascii', 'xmlcharrefreplace'))
      elif re.search(r'<allow_inactive>no</allow_inactive>', line):
        m = re_active.search(lines[index + 1])
        lines[index] = line.replace(
            '<allow_inactive>no</allow_inactive>',
            '<allow_inactive>%s</allow_inactive>' %
               m.group(1).encode('ascii', 'xmlcharrefreplace'))
    if original != lines:
      out.append((filename, original, lines))
  return out


if __name__ == '__main__':
  sys.exit(main())
