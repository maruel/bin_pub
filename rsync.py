#!/usr/bin/env python3
# coding: utf-8
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
"""rsync wrapper with saner defaults.

You specific the local and remote directories and it will copy them properly.
"""

import optparse
import string
import subprocess
import sys


def bash_escape(arg):
  """Escapes each character individually."""
  out = []
  allowed = string.digits + string.ascii_letters
  for i in arg:
    if i in allowed:
      out.append(i)
    else:
      # Escape anything else. Note this includes all UTF-8 characters and '/'
      # but "this works".
      out.append('\\' + i)
  return ''.join(out)


def quote_subpath(path):
  """Returns a shell quoted path with the host part double quoted.

  This works around a problem with rsync.
  """
  if ':' in path:
    host, path = path.split(':', 1)
    # We can't use pipe.quote() here because rsync is splitting the host from
    # the path and then improperly passing the value unquoted to the remote
    # shell.
    path = host + ':' + bash_escape(path)
  return path


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
  # It's tricky, the part _after_ the ssh host must be double quoted.
  src = quote_subpath(src)
  dst = quote_subpath(dst)
  cmd = [
    'rsync',
    '--verbose',
    '--rsh=/usr/bin/ssh',
    '--recursive',
    # Sync time
    '--times',
    # Don't copy perms
    '--no-perms',
    # Stats.
    '--stats',
    # Nice stats.
    '--human-readable',
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
        # Don't keep empty dirs. When it's not provided, this permits
        # incremental file list instead of having to parse it upfront in the
        # src.
        '--prune-empty-dirs',
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
  if not quiet:
    print(' '.join(cmd))
  return subprocess.call(cmd)


def main():
  parser = optparse.OptionParser(
      usage='%prog [src] [dst]',
      description=sys.modules[__name__].__doc__)
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
