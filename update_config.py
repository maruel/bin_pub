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

import maruel


def update_config(config_dir, incremental, fix):
    """Processes files in config_dir and copy them in the $HOME directory.

    If incremental is True, assume the content should be _inside_ the target
    content. Otherwise, assume the content should be at the beginning of the
    target content.

    Returns False if a difference was found.
    """
    if not os.path.isdir(config_dir):
        print('%s doesn\'t exists!' % config_dir)
        return False
    home_dir = os.environ['HOME']
    existing = []
    blacklist = [r'.*README$', r'.*\.swp$']
    for basename in maruel.walk(config_dir, [r'.*'], blacklist):
        src = os.path.join(config_dir, basename)
        dst = os.path.join(home_dir, basename)
        if os.path.isdir(src):
            if not os.path.isdir(dst):
                print('Creating directory %s' % dst)
                os.makedirs(dst)
            continue
        if not os.path.exists(dst):
            print('Copying %s' % basename)
            shutil.copyfile(src, dst)
        else:
            # Will process afterwards.
            existing.append((basename, src, dst))

    def check(src, dst):
        if incremental:
            return maruel.read(dst).endswith(maruel.read(src))
        else:
            return maruel.read(dst).startswith(maruel.read(src))

    ok_files = []
    retval = True
    for basename, src, dst in existing:
        if not check(src, dst):
            if fix:
                if incremental:
                    prev = ''
                    print('Appending to %s' % basename)
                    if os.path.isfile(dst):
                        prev = maruel.read(dst)
                    maruel.write(dst, prev + maruel.read(src))
                else:
                    # Destructive.
                    print('Overwritting %s' % basename)
                    if os.path.isfile(dst):
                        os.rename(dst, dst + '~')
                    maruel.write(dst, maruel.read(dst))
            else:
                # Diff. Note that diff will return 1 when there's a diff.
                print('Diffing %s' % basename)
                subprocess.call(['diff', '-u', src, dst])
            retval = False
        else:
            ok_files.append(basename)
    print('The following files are ok: %s' % ', '.join(ok_files))
    return retval


def main():
    parser = optparse.OptionParser()
    parser.add_option('-f', '--fix', action='store_true',
            help='"fix" the files')
    options, args = parser.parse_args()

    curpath = os.path.dirname(os.path.abspath(__file__))
    # Look for ~/bin/bin_pub pattern.
    if curpath == os.path.join(os.environ['HOME'], 'bin', 'bin_pub'):
        print('Doing public files')
        retval = update_config(
                os.path.join(curpath, 'configs'),
                False,
                options.fix)

        print('Doing private files')
        retval &= update_config(
                os.path.join(curpath, '..', 'configs'),
                True,
                options.fix)
        return not retval
    else:
        # Just sync public stuff.
        return not update_config(
                os.path.join(curpath, 'configs'),
                False,
                options.fix)


if __name__ == '__main__':
    sys.exit(main())

# vim: ts=4:sw=4:tw=80:et:
