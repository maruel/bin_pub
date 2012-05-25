#!/usr/bin/env python
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Updates the config files without destroying anything."""

import optparse
import os
import shutil
import subprocess
import sys
import tempfile

import maruel

BIN_PUB_DIR = os.path.dirname(os.path.abspath(__file__))


def update_config(files, diff_cmd):
    """Processes files in files and copy them in the $HOME directory."""
    home_dir = os.environ.get('HOME') or os.path.dirname(os.path.dirname(BIN_PUB_DIR))
    to_diff = []
    ok_files = []
    for basename, content in files.iteritems():
        dst = os.path.join(home_dir, basename)
        dst_dir = os.path.dirname(dst)
        if not os.path.isdir(dst_dir):
            os.makedirs(dst_dir)
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
        # Diff. Note that diff will return 1 when there's a diff.
        print('Diffing %s' % basename)
        with tempfile.NamedTemporaryFile() as f:
            maruel.write(f.name, files[basename])
            dst = os.path.join(home_dir, basename)
            subprocess.call(diff_cmd + [f.name, dst])
    print('The following files are ok: %s' % ', '.join(ok_files))


def load_files(config_dir, files):
    blacklist = [r'.*README$', r'.*\.swp$']
    for basename in maruel.walk(config_dir, [r'.*'], blacklist):
        src = os.path.join(config_dir, basename)
        if os.path.isfile(src):
            files.setdefault(basename, '')
            files[basename] += maruel.read(src)


def main():
    parser = optparse.OptionParser()
    options, args = parser.parse_args()
    if args:
      parser.error('Unsupported args %s' % args)

    files = {}
    load_files(os.path.join(BIN_PUB_DIR, 'configs'), files)

    # Look for ~/bin/bin_pub pattern.
    if os.path.basename(os.path.dirname(BIN_PUB_DIR)) == 'bin':
      load_files(os.path.join(BIN_PUB_DIR, '..', 'configs'), files)

    #update_config(files, ['diff', '-u'])
    update_config(files, ['vimdiff'])


if __name__ == '__main__':
    sys.exit(main())

# vim: ts=4:sw=4:tw=80:et:
