#!/usr/bin/env python3
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Updates the config files without destroying anything."""

import argparse
import difflib
import os
import shutil
import subprocess
import sys
import tempfile

BIN_PUB_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, BIN_PUB_DIR)

import maruel


class Symlink(object):
    def __init__(self, src):
        self.src = src


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
            os.write(handle, content.encode('utf-8'))
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
    for basename, content in sorted(files.items()):
        dst = os.path.join(home_dir, basename)
        if isinstance(content, Symlink):
            if not os.path.islink(dst):
                # Create a symlink.
                os.symlink(content.src, dst)
            continue
        dst_dir = os.path.dirname(dst)
        if not os.path.isdir(dst_dir):
            os.makedirs(dst_dir)
        if not os.path.isfile(dst):
            if os.path.isdir(dst):
                print('Skipping file which is directory at destination %s' %
                        basename)
                continue
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
    """Loads all the files content into dictionary |files|.

    Appends the content if an entry is already present.
    """
    blacklist = [r'.*README.md$', r'.*\.swp$']
    skips = []
    for basename in maruel.walk(config_dir, [r'.*'], blacklist):
        src = os.path.join(config_dir, basename)
        if any(basename.startswith(s) for s in skips):
            # Inside one of the symlinked directory.
            continue
        if src.endswith(os.sep):
            if os.path.exists(src + '.git'):
                # Do a symlink instead and skip everything in this directory.
                files[basename[:-1]] = Symlink(src[:-1])
                skips.append(basename)
        else:
            if basename not in files:
                files[basename] = maruel.read(src)
            else:
                files[basename] += maruel.read(src)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-u', action='store_true', help='Unified diff')
    parser.add_argument(
            '--dry-run', action='store_true', help='Do not modify files')
    args = parser.parse_args()

    files = {}
    load_files(os.path.join(BIN_PUB_DIR, 'configs'), files)

    # Look for ~/bin/bin_pub pattern.
    if os.path.basename(os.path.dirname(BIN_PUB_DIR)) == 'bin':
      load_files(os.path.join(BIN_PUB_DIR, '..', 'configs'), files)

    cmd = ['vim', '-d']
    if args.u:
        cmd = ['diff', '-u']
    if args.dry_run:
        l = max(len(l) for l in files)
        for f in sorted(files):
            print('%-*s' % (l, f))
        return
    return update_config(files, cmd)


if __name__ == '__main__':
    sys.exit(main())

# vim: ts=4:sw=4:tw=80:et:
