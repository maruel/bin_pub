# Copyright 2011 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

"""Defines many small utility functions to speed up writing small scripts in
python.

To be used as
from maruel import *
"""

import logging
import os
import pprint
import re
import shutil
import subprocess
import sys

# Detect the path of the main script.
root_dir = os.path.dirname(os.path.abspath(sys.modules['__main__'].__file__))


def call(args, *a, **kwargs):
    """Autosplit arguments"""
    if isinstance(args, basestring):
        args = args.split(' ')
    return subprocess.check_call(args, *a, **kwargs)


def capture(*args, **kwargs):
    """Calls a process and returns the stdout"""
    return call(*args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        **kwargs)[0]


def write(filename, content):
    """Writes a file"""
    mode = 'wb' if filename.endswith('.png') else 'wt'
    with open(filename, mode) as f:
        f.write(content)


def read(filename):
    """Reads a file"""
    mode = 'rb' if filename.endswith('.png') else 'rt'
    with open(filename, mode) as f:
        return f.read()


def walk(path, whitelist, blacklist=(r'^(.*/|)\.[^/]+/$',), relative=True):
    """Walks a directory and returns matching files and directories.

    Returned paths are relative to 'path' if relative=True.
    Directories have a trailing os.sep to ease regexing.
    """
    whitelist = [re.compile(x) for x in whitelist]
    whitelisted = lambda x: any(r.match(x) for r in whitelist)
    blacklist = [re.compile(x) for x in blacklist]
    blacklisted = lambda x: any(r.match(x) for r in blacklist)
    out = []
    lenpath = len(path)
    for dirpath, dirnames, filenames in os.walk(path):
        assert dirpath.startswith(path)
        if relative:
            dirpath = dirpath[lenpath + 1:]
        for index in range(len(dirnames) - 1, -1, -1):
            d = os.path.join(dirpath, dirnames[index]) + os.sep
            posix_d = d.replace(os.sep, '/')
            if blacklisted(posix_d):
                # This speeds up searching by blacklisting directories that
                # should not be looked into like .git or .svn.
                dirnames.pop(index)
            elif whitelisted(posix_d):
                out.append(d)
        for f in filenames:
            f = os.path.join(dirpath, f)
            posix_f = f.replace(os.sep, '/')
            if not blacklisted(posix_f) and whitelisted(posix_f):
                out.append(f)
    return sorted(out)


def clamp_str(string, **kwargs):
    """Returns 'foo...' for clamped strings.

    Args:
      maxlen: limits of the string length
      eat_lf: if True, replaces \n with their textual representation
      <Ignores other arguments>
    """
    maxlen = kwargs.get('maxlen', 50)
    if maxlen > 3 and len(string) >= (maxlen - 2):
        string = string[0:maxlen-3] + '...'
    if kwargs.get('eat_lf', False):
        string = string.replace('\n', r'\n').replace('\r', r'\r')
    return string


def obj_dump(obj, **kwargs):
    """Stringnizes a object for logging purpose.

    Args:
      depth: Recursion limit
      <All arguments supported by clamp_str>
    """
    assert not (set(kwargs.keys()) - set(('maxlen', 'eat_lf', 'depth')))
    kwargs.setdefault('maxlen', 50)
    kwargs.setdefault('depth', 3)
    kwargs['depth'] = kwargs['depth'] - 1
    recurse = kwargs['depth'] > 0
    if isinstance(obj, (basestring)):
        return '\'%s\'' % clamp_str(str(obj), **kwargs)
    if isinstance(obj, (int, float)) or obj is None:
        return clamp_str(str(obj), **kwargs)
    if isinstance(obj, tuple):
        kwargs['maxlen'] -= 2
        if recurse:
            inner = clamp_str(', '.join(obj_dump(o, **kwargs) for o in obj),
                              **kwargs)
        else:
            inner = 'len=%d' % len(obj)
        return '(%s)' % inner
    if isinstance(obj, list):
        kwargs['maxlen'] -= 2
        if recurse:
            inner = clamp_str(', '.join(obj_dump(o, **kwargs) for o in obj),
                              **kwargs)
        else:
            inner = 'len=%d' % len(obj)
        return '[%s]' % inner
    if isinstance(obj, dict):
        kwargs['maxlen'] -= 2
        if recurse:
            keys = sorted(
                k for k in obj.iterkeys()
                if not isinstance(k, basestring) or not k.startswith('__'))
            inner = clamp_str(
                ', '.join(
                    '%s=%s' % (
                        obj_dump(k, **kwargs), obj_dump(obj[k], **kwargs))
                    for k in keys),
                **kwargs)
        else:
            inner = 'len=%d' % len(obj)
        return '{%s}' % inner
    if not hasattr(obj, '__class__'):
        return clamp_str(str(obj), **kwargs)
    objname = obj.__class__.__name__
    kwargs['maxlen'] -= (len(objname) + 2)
    if isinstance(obj, (frozenset, set)):
        if recurse:
            inner = clamp_str(
                ', '.join(obj_dump(o, **kwargs) for o in obj), **kwargs)
        else:
            inner = 'len=%d' % len(obj)
        return '%s(%s)' % (objname, inner)
    classmembers = dir(obj.__class__)
    members = [m for m in dir(obj)
              if (not m.startswith('__') and not m in classmembers and
                  not callable(getattr(obj, m)))]
    if recurse:
        out = (clamp_str('%s: %s' % (m, obj_dump(getattr(obj, m), **kwargs)),
                        **kwargs)
              for m in sorted(members))
    else:
        out = ('nb_members=%d' % len(members),)
    if out:
        return '%s[%s]' % (objname, clamp_str(', '.join(out), **kwargs))
    return objname


def log_function(
    f,
    name=None,
    logcall=True,
    logreturn=True,
    outfn=None,
    **outer_kwargs):
    """Logs function calls.

    Args:
      name: overrides the function name
      logcall: logs function calls
      logreturn: logs the function returns
      outfn: sets to logging.debug to use logging instead of print
      <All arguments supported by obj_dump>
    """
    if getattr(f, 'logged', None) == True:
        # Override logging.
        f = f.inner
    name = name or f.func_name
    def wrapped(*args, **kwargs):
        # Nicely format the arguments.
        argstr = obj_dump(', '.join(
            list(obj_dump(a, **outer_kwargs) for a in args) +
            ['%s=%s' % (obj_dump(k, **outer_kwargs),
                        obj_dump(v, **outer_kwargs))
            for k, v in kwargs.iteritems()]), **outer_kwargs)
        if logcall:
            if outfn:
                outfn('***%s(%s)' % (name, argstr))
            else:
                print('***%s(%s)' % (name, argstr))
        result = f(*args, **kwargs)
        if logreturn:
            if outfn:
                outfn('***%s(%s) returned [%s]' % (
                    name, argstr, obj_dump(result, **outer_kwargs)))
            else:
                print('***%s(%s) returned [%s]' % (
                    name, argstr, obj_dump(result, **outer_kwargs)))
        return result
    for member in dir(f):
        if member in ('__class__'):
            continue
        setattr(wrapped, member, getattr(f, member))
    wrapped.inner = f
    wrapped.logged = True
    return wrapped


def log_class(cls, **kwargs):
    """Logs function calls for all the functions in the class."""
    for member in dir(cls):
        try:
            memobj = getattr(cls, member)
            if callable(memobj) and not member.startswith('__'):
                setattr(cls, member, log_function(memobj, **kwargs))
        except AttributeError:
            continue

# vim: ts=4:sw=4:tw=80:et:
