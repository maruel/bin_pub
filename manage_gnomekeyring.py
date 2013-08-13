#!/usr/bin/python
# Copyright 2013 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Prints all the passwords in gnome keyring. Can optionally remove items.

It is useful to catch unsalted unhashed keys.
"""

import datetime
import getpass
import logging
import optparse
import os
import sys
import time

try:
    import gnomekeyring
except ImportError:
    gnomekeyring = None

import natsort


def unlock_keyring():
    """Tries to unlock the gnome keyring. Returns True on success."""
    try:
        gnomekeyring.unlock_sync(
                None, getpass.getpass('Keyring password: '))
        return True
    except Exception as e:
        print >> sys.stderr, 'Failed to unlock keyring: %s' % e
        return False


class GnomeKeyringItem(object):
    def __init__(self, container, itemid, item):
        self.container = container
        self.itemid = itemid
        self.item = item
        self.name = self.item.get_display_name()
        self.attr = gnomekeyring.item_get_attributes_sync(
                self.container, self.itemid)
        mtime = time.gmtime(self.item.get_mtime())[:7]
        self.timestamp = str(datetime.datetime(*mtime)).split('.', 1)[0]
        attrstr = '; '.join('%s=%s' % (k, v) for k, v in self.attr.iteritems())
        self._str = '%-2d %s %s = %s; %s' % (
                self.itemid,
                self.timestamp,
                self.name,
                self.item.get_secret(),
                attrstr)

    def __str__(self):
        return self._str


def get_all_gnomekeyring_entries():
    """Returns a dict of all keyring containers with a list of all their
    entries.

    Entries are sorted by timestamp.
    """
    out = {}
    tried_to_unlock = False
    for c in gnomekeyring.list_keyring_names_sync():
        out[c] = []
        for i in gnomekeyring.list_item_ids_sync(c):
            item = None
            try:
                item = gnomekeyring.item_get_info_sync(c, i)
            except gnomekeyring.IOError as e:
                logging.info('%s', e)
                if not tried_to_unlock:
                    tried_to_unlock = True
                    if unlock_keyring():
                        # Try again.
                        try:
                            item = gnomekeyring.item_get_info_sync(c, i)
                        except gnomekeyring.IOError as e:
                            logging.info('%s', e)
            if item:
                out[c].append(GnomeKeyringItem(c, i, item))
            else:
                logging.error('Failed to access %s-%-2d: %s', c, i, e)
        natsort.natsort(out[c], key=str)
    return out


def print_all(all_entries):
    for container in sorted(all_entries):
        items = all_entries[container]
        if not items:
            print('[%s]:\n  --empty--' % container)
            continue
        print('[%s]:' % container)
        print('\n'.join('  %s' % i for i in items))


def main():
    parser = optparse.OptionParser(description=sys.modules[__name__].__doc__)
    levels = [logging.ERROR, logging.INFO, logging.DEBUG]
    parser.add_option(
            '-v', '--verbose', action='count', default=0,
            help='Produces additional output for diagnostics. Can be used up '
                 'to %d times for more logging info.' % (len(levels) - 1))
    parser.add_option(
            '-r', '--rm',
            default=[],
            action='append',
            nargs=2,
            metavar='\'container itemid\'',
            help='Remove an entry, for example: --rm login 3. Can be specified '
                 'multiple times')
    options, args = parser.parse_args()
    logging.basicConfig(
            level=levels[min(options.verbose, len(levels) - 1)],
            format='%(module)s(%(lineno)d) %(funcName)s:%(message)s')

    if args:
        parser.error('Unsupported arg: %s' % args)

    if not os.environ.get('DISPLAY') or not gnomekeyring:
        parser.error(
                'Make sure to be inside an X session. Starting your '
                'screen/tmux session under X and then using \'screen -x\' back '
                'to it through ssh will work just fine.')
        return False

    # Sets up app name.
    import pygtk
    pygtk.require('2.0')
    import gtk  # pylint: disable=W0612

    if options.rm:
        tried_to_unlock = False
        ret = 0
        for rm in options.rm:
            try:
                gnomekeyring.item_delete_sync(rm[0], int(rm[1]))
            except gnomekeyring.IOError as e:
                logging.info('%s', e)
                if not tried_to_unlock:
                    tried_to_unlock = True
                    if unlock_keyring():
                        # Try again.
                        try:
                            gnomekeyring.item_delete_sync(rm[0], int(rm[1]))
                            continue
                        except gnomekeyring.IOError as e:
                            logging.info('%s', e)
                print >> sys.stderr, 'Failed to delete %s #%s' % (rm[0], rm[1])
                ret = 1
        return ret

    all_entries = get_all_gnomekeyring_entries()
    print_all(all_entries)
    return 0


if __name__ == '__main__':
    sys.exit(main())

# vim: ts=4:sw=4:tw=80:et:
