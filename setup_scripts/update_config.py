#!/usr/bin/env python
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Updates the config files without destroying anything."""

import difflib
import optparse
import os
import shutil
import subprocess
import sys
import tempfile

BIN_PUB_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, BIN_PUB_DIR)

import maruel



def diff(diff_cmd, dst, basename, content):
    """Diffs the destination file with the content it should be."""
    old_size = 0
    if os.path.isfile(dst):
        old_size = os.stat(dst).st_size
    print(
        'Diffing %-16s  new: %5d bytes  current: %5d bytes' % (
            basename, len(content), old_size))
    handle, name = tempfile.mkstemp()
    try:
        try:
            os.write(handle, content)
        finally:
            os.close(handle)
        result = subprocess.call(
            diff_cmd + [name, dst], shell=sys.platform=='win32')
        if result:
            return result
        # Look if the source content changed.
        actual_content = maruel.read(name)
        if actual_content != content:
            # The user modified the source. For now just quit early.
            print('You modified the source')
            for i in difflib.unified_diff(
                    content.splitlines(True),
                    actual_content.splitlines(True),
                    fromfile=basename,
                    tofile=basename):
                sys.stdout.write(i)
            return 1
    finally:
        os.remove(name)
    return 0


def update_config(files, diff_cmd):
    """Processes files in files and copy them in the $HOME directory."""
    home_dir = os.environ.get('HOME') or os.environ['USERPROFILE']
    to_diff = []
    ok_files = []
    for basename in sorted(files):
        dst = os.path.join(home_dir, basename)
        dst_dir = os.path.dirname(dst)
        if not os.path.isdir(dst_dir):
            os.makedirs(dst_dir)
        content = files[basename]
        if not os.path.isfile(dst):
            print('Copying %s' % basename)
            maruel.write(dst, content)
            ok_files.append(basename)
        else:
            if maruel.read(dst) != content:
                to_diff.append(basename)
            else:
                ok_files.append(basename)

    for basename in to_diff:
        result = diff(
            diff_cmd, os.path.join(home_dir, basename), basename, files[basename])
        if result:
            return result
    print('The following files are ok:')
    for f in ok_files:
      print('  ' + f)


def load_files(config_dir, files):
    """Loads all the files content into dictionnary |files|.

    Appends the content if an entry is already present.
    """
    blacklist = [r'.*README.md$', r'.*\.swp$']
    for basename in maruel.walk(config_dir, [r'.*'], blacklist):
        src = os.path.join(config_dir, basename)
        if os.path.isfile(src):
            files.setdefault(basename, '')
            files[basename] += maruel.read(src)


def main():
    parser = optparse.OptionParser()
    parser.add_option('-u', action='store_true', help='Unified diff')
    options, args = parser.parse_args()
    if args:
      parser.error('Unsupported args %s' % args)

    files = {}
    load_files(os.path.join(BIN_PUB_DIR, 'configs'), files)

    # Look for ~/bin/bin_pub pattern.
    if os.path.basename(os.path.dirname(BIN_PUB_DIR)) == 'bin':
      load_files(os.path.join(BIN_PUB_DIR, '..', 'configs'), files)

    cmd = ['vim', '-d']
    if options.u:
        cmd = ['diff', '-u']
    return update_config(files, cmd)


if __name__ == '__main__':
    sys.exit(main())

# vim: ts=4:sw=4:tw=80:et:
