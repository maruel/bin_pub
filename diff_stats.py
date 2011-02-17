#!/usr/bin/python
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

import re
import string
import subprocess
import sys


def check_capture(args, **kwargs):
    kwargs['stdout'] = subprocess.PIPE
    kwargs['stderr'] = subprocess.STDOUT
    proc = subprocess.Popen(args, **kwargs)
    out = proc.communicate()
    if proc.returncode:
        raise Exception('Oh Fuck; Acid kicks in')
    return out[0]


def get_branches(cwd):
    return [
        i[2:] for i in check_capture(['git', 'branch'], cwd=cwd).splitlines()
    ]


def diff_stats(cwd):
    """Prints the diff stats for the pipelined branches."""
    branches = get_branches(cwd)
    for branch in branches:
        match = re.match(r'^(\d+)(\w*?)_.*$', branch)
        if match:
            branch_number = int(match.group(1))
            if not branch_number:
                continue
            postfix = match.group(2)
            prefix = '%d%s_' % ((branch_number - 1), postfix)
            prev_branches = [i for i in branches if i.startswith(prefix)]
            if len(prev_branches) == 1:
                delta = '%s..%s' % (prev_branches[0], branch)
                print delta
                sys.stdout.flush()
                # Force color so diff_stats.py | less produces useful output
                # when os.environ['LESS'] == '-R'.
                subprocess.check_call(
                    ['git', 'diff', '--stat', '--color', delta], cwd=cwd)


if __name__ == '__main__':
    diff_stats(None)

# vim: ts=4:sw=4:tw=80:et:
