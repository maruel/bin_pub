#!/usr/bin/python
# Copyright 2013 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Prints all the passwords in gnome keyring. Can optionally remove items.

It is useful to catch unsalted unhashed keys.
"""

import datetime
import optparse
import sys
import time

import pygtk
pygtk.require('2.0')

import gtk # sets app name
import gnomekeyring

import natsort


class Item(object):
    def __init__(self, container, itemid):
        self.container = container
        self.itemid = itemid
        self.item = gnomekeyring.item_get_info_sync(self.container, self.itemid)
        self.name = self.item.get_display_name()
        self.attr = gnomekeyring.item_get_attributes_sync(
                self.container, self.itemid)
        line = '[%s] %s '
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


def get_all_entries():
    """Returns a dict of all keyring containers with a list of all their
    entries.

    Entries are sorted by timestamp.
    """
    return dict(
        (c, sorted(
            (Item(c, i) for i in gnomekeyring.list_item_ids_sync(c)),
            cmp=natsort.natcmp,
            key=str))
        for c in gnomekeyring.list_keyring_names_sync()
    )


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
    parser.add_option(
            '-r', '--rm',
            default=[],
            action='append',
            nargs=2,
            metavar='\'container itemid\'',
            help='Remove an entry, for example: --rm login 3. Can be specified '
                 'multiple times')
    options, args = parser.parse_args()

    if args:
        parser.error('Unsupported arg: %s' % args)

    if options.rm:
        for rm in options.rm:
            gnomekeyring.item_delete_sync(rm[0], int(rm[1]))
        return 0

    all_entries = get_all_entries()
    print_all(all_entries)
    return 0


if __name__ == '__main__':
    sys.exit(main())

# vim: ts=4:sw=4:tw=80:et:
