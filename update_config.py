#!/usr/bin/env python
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Updates the config files without destroying anything."""

import os
import shutil
import subprocess
import maruel


def update_config(config_dir, incremental):
    """Processes files in config_dir and copy them in the $HOME directory.

    If incremental is True, assume the content should be _inside_ the target
    content. Otherwise, assume the content should be at the beginning of the
    target content.
    """
    home_dir = os.environ['HOME']
    existing = []
    for basename in maruel.walk(config_dir, [r'.*'], [r'README$']):
        src = os.path.join(config_dir, basename)
        dst = os.path.join(home_dir, basename)
        if os.path.isdir(src) and not os.path.isdir(dst):
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
            return maruel.read(dst).startswith(maruel.read(dst))
        else:
            return maruel.read(dst).endswith(maruel.read(dst))

    for basename, src, dst in existing:
        print('Verifying %s' % basename)
        if not check(src, dst):
            # Diff. Note that diff will return 1 when there's a diff.
            print('Diffing %s' % basename)
            subprocess.call(['diff', src, dst])



def main():
    curpath = os.path.dirname(os.path.abspath(__file__))
    update_config(os.path.join(curpath, 'configs'), False)


if __name__ == '__main__':
    main()

# vim: ts=4:sw=4:tw=80:et:
