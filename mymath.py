#!/usr/bin/env python3
# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Support python-style calculation at the command-line including time.

If no argument is provided, reads arguments from stdin.
"""

import re
import sys


TIME_FACTORS = [60, 60, 24, 365, 0]


def to_sec(amount):
  """Converts a string YEARS:DAYS:HOURS:MINUTES:SECONDS.FRACTION into seconds.

  The YEARS and DAYS is approximative, since it doesn't take in account leap
  seconds and leap years.
  """
  # TODO(maruel): Support negative.
  fraction = ''
  if '.' in amount:
    amount, fraction = amount.split('.', 1)
  result = 0
  items = amount.split(':')
  for i in range(len(items)):
    result = result * TIME_FACTORS[len(items) - i - 1] + int(items[i] or '0')
  if fraction:
    result = float(result) + (float(fraction) / (10**len(fraction)))
  return result


def to_time(seconds):
  """Convert an amount in seconds back into human readable time.

  YEARS:DAYS:HOURS:MINUTES:SECONDS.FRACTION.
  """
  # TODO(maruel): Support negative.
  fraction = None
  if isinstance(seconds, float):
    int_seconds = int(seconds)
    fraction = seconds - float(int_seconds)
    seconds = int_seconds

  out = []
  i = 0
  while seconds:
    if not TIME_FACTORS[i]:
      out.append('%d' % seconds)
      break
    out.append('%02d' % (seconds % TIME_FACTORS[i]))
    seconds /= TIME_FACTORS[i]
    i += 1

  out = ':'.join(reversed(out)).lstrip('0') or '0'
  if fraction:
    # TODO(maruel): Broken
    out += str(fraction)[1:]
  return out


def calc(equation):
  """Evaluates an equation, accepting time values."""
  items = [i for i in re.split(r'([\d\:]+)', equation) if i]
  has_time = False
  for i, v in enumerate(items):
    if ':' in v:
      has_time = True
      items[i] = to_sec(v)

  result = eval(''.join(map(str, items)))
  if has_time:
    result = '%s  (%s)' % (to_time(result), result)
  return str(result)


def unit_test():
  CANONICAL = [
    ('1', 1),
    ('1.1', 1.1),
    ('1:00', 60),
    ('1:00.11', 60.11),
    ('1:00:00', 3600),
    ('1:00:01', 3601),
    ('1:00:01.02', 3601.02),
    ('1:01:00', 3660),
    ('1:00:00:00', 86400),
    ('1:00:00:00:00', 31536000),
  ]
  NON_REVERSIBLE = [
    ('0001', 1),
    ('1:', 60),
    ('1:.10', 60.1),
    ('1:000', 60),
    ('1::', 3600),
    ('1:::', 86400),
    ('1::::', 31536000),
  ]
  for value, expected in CANONICAL + NON_REVERSIBLE:
    actual = to_sec(value)
    assert expected == actual, (expected, actual)
  for expected, value in CANONICAL:
    actual = to_time(value)
    assert expected == actual, (expected, actual)
  EQUATIONS = [
      ('1+1', '2'),
      ('10**1', '10'),
      ('10**(2+3)', '100000'),
      (' 10  **  ( 2 + 3 ) ', '100000'),
      ('10:00 + (2+3)', '10:05  (605)'),
      ('10:', '10:00  (600)'),
      ('600**2', '360000'),
      ('10:**2', '4:04:00:00  (360000)'),
      ('1/2', '0'),
      ('1./2', '0.5'),
      ('1+3*2', '7'),
  ]
  for value, expected in EQUATIONS:
    actual = calc(value)
    assert expected == actual, (expected, actual)


def main(args):
  unit_test()
  if not args:
    while True:
      equation = sys.stdin.readline().strip()
      if not equation:
        return 0
      print('  = %s' % calc(equation))
  else:
    for equation in args:
      print('%s = %s' % (equation, calc(equation)))
  return 0


if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
