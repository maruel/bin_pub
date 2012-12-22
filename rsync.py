#!/usr/bin/python
# coding: utf-8
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
"""rsync wrapper."""

import optparse
import subprocess
import sys


def rsync(
    src, dst,
    delete,
    resume=False,
    excludes=('*bak', '*~'),
    quiet=False,
    bandwidth=None):
  """Calls rsync correctly, sync everything in src into dst.
  http://samba.anu.edu.au/ftp/rsync/rsync.html

  Args:
  - resume will resume (append to) the file copy instead of starting over
  - quiet remove progress, for cron job
  - Bandwidth is in KBytes per second.
  """
  # "A trailing slash on the source changes this behavior to avoid creating an
  #  additional directory level at the destination."
  src = src.rstrip('/') + '/'
  dst = dst.rstrip('/')
  cmd = [
    'rsync',
    '--verbose',
    '--stats',
    '--rsh=/usr/bin/ssh',
    '--recursive',
    # Sync time
    '--times',
    # Don't keep empty dirs
    '--prune-empty-dirs',
    # Don't copy perms
    '--no-perms',
  ]
  if delete:
    cmd.extend(
      [
        # Delete deleted files
        '--delete',
        # Create ~ files instead of deleting
        '--backup',
        # Existing excluded files will be deleted
        '--delete-excluded',
      ])

  for exclusion in excludes:
    cmd.extend(('--exclude', exclusion))

  if resume:
    # Implies --inplace and --partial
    # Breaks "backups as hardlinks"
    # Solution: using separate HDs requires copies anyway.
    cmd += ['--append-verify']
    # Search more for file move since bandwidth is scarce.
    cmd += ['--fuzzy']

  if not quiet:
    cmd += ['--progress']

  if bandwidth and ':' in src:
    # Only limit for non local syncs.
    cmd += ['--bwlimit=%s' % bandwidth]

  cmd += [src, dst]
  return subprocess.call(cmd)


def main():
  parser = optparse.OptionParser(usage='%prog [src] [dst]')
  parser.add_option('-q', '--quiet', action='store_true')
  parser.add_option(
      '-d', '--delete', action='store_true',
      help='Delete remote files that are not present locally')
  options, args = parser.parse_args()
  if len(args) != 2:
    parser.error('Specify the src and dst')
  return rsync(args[0], args[1], delete=options.delete, quiet=options.quiet)


if __name__ == '__main__':
  sys.exit(main())
