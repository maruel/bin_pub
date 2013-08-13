#!/usr/bin/python
# Copyright 2013 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Prints all the passwords in gnome keyring or OSX keychain.

Can optionally remove items. It is useful to catch unsalted unhashed keys. The
keys are salted on the hostname so the keys won't match if the FQDN changes.
"""

import datetime
import getpass
import hashlib
import logging
import optparse
import os
import socket
import sys
import time

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, BASE_DIR)

try:
    import gnomekeyring
except ImportError:
    gnomekeyring = None
try:
    import keyring
except ImportError:
    keyring = None
try:
    sys.path.insert(0, os.path.join(BASE_DIR, 'keychain'))
    import keychain
except ImportError:
    keychain = None

import natsort


def gnomekeyring_unlock():
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


def gnomekeyring_get_all_entries():
    """Returns a dict of all keyring containers with a list of all their
    entries.
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
                    if gnomekeyring_unlock():
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


def gnomekeyring_retrieve_password(bucket, key):
    """Returns the password for the corresponding key.

    Tries to use keyring if available, and unlock it if possible. Falls back to
    ask the user for the password but tries to store the password back in
    keyring if available.

    The key is salted and hashed so the direct mapping between an email address
    and its password is not stored directly in the keyring.
    """
    # Create a salt out of the bucket name.
    salt = hashlib.sha512('1234' + bucket + '1234').digest()
    # Create a salted hash from the key.
    actual_key = hashlib.sha512(salt + key).hexdigest()

    try:
        logging.info('Getting password for key %s (%s)', key, actual_key)
        value = keyring.get_password(bucket, actual_key)
        if value is not None:
            print value
            return 0
    except Exception as e:
        print >> sys.stderr, 'Failed to get password from keyring: %s' % e
        if gnomekeyring_unlock():
            # Unlocking worked, try getting the password again.
            try:
                value = keyring.get_password(bucket, actual_key)
                if value is not None:
                    print value
                    return 0
            except Exception as e:
                print >> sys.stderr, 'Failed to get password from keyring: %s' % e

    # At this point, it failed to get the password from keyring. Ask the user.
    value = getpass.getpass('Please enter the password: ')

    try:
        logging.info('Saving password for key %s (%s)', key, actual_key)
        keyring.set_password(bucket, actual_key, value)
        return 0
    except Exception as e:
        print >> sys.stderr, 'Failed to save in keyring: %s' % e
        return 1


def gnomekeyring_delete_secrets(items):
    tried_to_unlock = False
    ret = 0
    for container, itemid in items:
        itemid = int(itemid)
        try:
            gnomekeyring.item_delete_sync(container, itemid)
        except gnomekeyring.IOError as e:
            logging.info('%s', e)
            if not tried_to_unlock:
                tried_to_unlock = True
                if gnomekeyring_unlock():
                    # Try again.
                    try:
                        gnomekeyring.item_delete_sync(container, itemid)
                        continue
                    except gnomekeyring.IOError as e:
                        logging.info('%s', e)
            print >> sys.stderr, 'Failed to delete %s #%d' % (container, itemid)
            ret = 1
    return ret


def keychain_get_entries(keymaster, k):
    return natsort.natsorted(
        '; '.join('%s=%s' % (i, j) for i, j in a.iteritems())
        for a in keymaster.list_keychain_accounts(k))


def keychain_get_all_entries(keymaster):
    """Returns a dict of all keyring containers with a list of all their
    entries.
    """
    return dict(
        (k, keychain_get_entries(keymaster, k))
        for k in keymaster.list_keychains())


def print_all(all_entries):
    """Prints all the keyring entries."""
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
    parser.add_option(
            '-g', '--get', metavar='KEY',
            help='Retrieves (or set if unset) a password for the specified key')
    parser.add_option(
            '-c', '--container', metavar='NAME',
            help='Only acts on one container|keychain')
    options, args = parser.parse_args()
    logging.basicConfig(
            level=levels[min(options.verbose, len(levels) - 1)],
            format='%(module)s(%(lineno)d) %(funcName)s:%(message)s')

    if args:
        parser.error('Unsupported arg: %s' % args)

    if options.rm and options.get:
        parser.error('Use one of --rm or --get, not both')


    if gnomekeyring:
        if not os.environ.get('DISPLAY'):
            parser.error(
                    'Make sure to be inside an X session. Starting your '
                    'screen/tmux session under X and then using \'screen -x\' '
                    'back to it through ssh will work just fine.')
        # Sets up app name.
        import pygtk
        pygtk.require('2.0')
        import gtk  # pylint: disable=W0612

        if options.rm:
            return gnomekeyring_delete_secrets(options.rm)

        if options.get:
            bucket = 'manage_gnomekeyring_%s' % socket.getfqdn()
            return gnomekeyring_retrieve_password(bucket, options.get)

        all_entries = gnomekeyring_get_all_entries()

    elif keychain:
        if options.get:
            parser.error('--get is still not implemented.')
        if options.rm:
            parser.error('--rm is still not implemented.')

        keymaster = keychain.Keychain()
        if options.container:
            all_entries = {
                options.container: keychain_get_entries(
                  keymaster, options.container),
            }
        else:
            all_entries = keychain_get_all_entries(keymaster)
    else:
        parser.error('Failed to load anything meaningful')

    print_all(all_entries)
    return 0


if __name__ == '__main__':
    sys.exit(main())

# vim: ts=4:sw=4:tw=80:et:
