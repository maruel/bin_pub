#!/usr/bin/env python3
# Copyright (c) 2011 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Intelligent natural sort implementation.

Can be used in a pipe to naturally short output.
"""

import functools
import re
import sys


@functools.total_ordering
class _Item(object):
  #__slots__ = ('i')
  def __init__(self, i):
    self.i = i
  def __lt__(self, rhs):
    if type(self.i) != type(rhs.i):
      return type(self.i) == str
    return self.i < rhs.i
  def __eq__(self, rhs):
    return self.i == rhs.i


def key(s):
  """Natural string comparison key."""
  if not isinstance(s, str):
    return (_Item(s),)
  return tuple(_Item(int(x) if x.isdigit() else x) for x in re.findall(r'(\d+|\D+)', s))


def ikey(x):
  """Natural string comparison key ignoring case."""
  return key(x.lower() if hasattr(x, 'lower') else x)


def sort(seq, key=key, *args, **kwargs):
  """In-place natural string sort.

  >>> a = ['3A2', '3a1']
  >>> sort(a, key=ikey)
  >>> a
  ['3a1', '3A2']
  >>> a = ['3a2', '3A1']
  >>> sort(a, key=key)
  >>> a
  ['3A1', '3a2']
  >>> a = ['3A2', '3a1']
  >>> sort(a, key=ikey)
  >>> a
  ['3a1', '3A2']
  >>> a = ['3a2', '3A1']
  >>> sort(a, key=ikey)
  >>> a
  ['3A1', '3a2']
  """
  seq.sort(key=key, *args, **kwargs)


def sorted(seq, key=key, *args, **kwargs):
  """Returns a copy of seq, sorted by natural string sort.

  >>> sorted(i for i in [4, '3a', '2', 1])
  [1, '2', '3a', 4]
  >>> sorted(['a4', 'a30'])
  ['a4', 'a30']
  >>> sorted(['3A2', '3a1'], key=ikey)
  ['3a1', '3A2']
  >>> sorted(['3a2', '3A1'], key=ikey)
  ['3A1', '3a2']
  >>> sorted(['3A2', '3a1'], key=ikey)
  ['3a1', '3A2']
  >>> sorted(['3a2', '3A1'], key=ikey)
  ['3A1', '3a2']
  >>> sorted(['3A2', '3a1'])
  ['3A2', '3a1']
  >>> sorted(['3a2', '3A1'])
  ['3A1', '3a2']
  >>> sorted(['1', ' 10'])
  [' 10', '1']
  >>> sorted([' 1', '10'])
  [' 1', '10']
  """
  return __builtins__.sorted(seq, key=key, *args, **kwargs)


def main():
  import doctest
  doctest.testmod()

  try:
    if len(sys.argv) > 1:
      with open(sys.argv[1], 'r') as f:
        lines = f.readlines()
    else:
      lines = sys.stdin.readlines()
  except:
    pass
  sys.stdout.write(''.join(sorted(lines)))
  return 0


if __name__ == '__main__':
  sys.exit(main())
