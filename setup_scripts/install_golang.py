#!/usr/bin/env python
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

import argparse
import os
import shutil
import subprocess
import tarfile
import sys


def from_sources():
  """Installing from sources."""
  goroot = os.environ['GOROOT']
  print('Installing Go in %s' % goroot)
  if os.path.isdir(goroot):
    subprocess.check_call(['git', 'fetch', '--all'], cwd=goroot)
  else:
    subprocess.check_call(
        ['git', 'clone', 'https://go.googlesource.com/go', goroot])

  #TAG="$(git tag | grep "^go" | egrep -v "beta|rc" | tail -n 1)"
  tags = subprocess.check_output(['git', 'tag'], cwd=goroot).splitlines()
  tags = sorted(
      t for t in tags
      if t.startswith('go') and 'beta' not in t and 'rc' not in t)
  tag = tags[-1]
  print('Using %s' % tag)
  subprocess.check_call(['git', 'checkout', tag], cwd=goroot)

  print('Building.')
  subprocess.check_call(['./make.bash'], cwd=os.path.join(goroot, 'src'))


def from_binary():
  """Install globally from pre-built binaries as root."""
  goroot = '/usr/local/go'
  print('Installing Go in %s' % goroot)
  if os.path.isdir(goroot):
    shutil.rmtree(goroot)
  # TODO(maruel): Magically figure out latest version.
  version = '1.7.4'
  uname = os.uname()[4]
  arch = 'amd64'
  if uname.startswith('arm'):
    # ~70MB, at 1Mbit it takes 12 minutes...
    arch = 'armv6l'
  if sys.platform == 'linux2':
    os_name = 'linux'
  filename = 'go' + version + '.' + os_name + '-' + arch + '.tar.gz'
  url = 'https://storage.googleapis.com/golang/' + filename
  print('Fetching %s' % url)
  subprocess.check_call(['wget', url])
  subprocess.check_call(['tar', '-C', '/usr/local', '-xzf', filename])
  os.remove(filename)
  with open('/etc/profile.d/golang.sh', 'wb') as f:
    f.write('export PATH="$PATH:%s/bin"\n' % goroot)
  os.chmod('/etc/profile.d/golang.sh', 0555)


def main():
  parser = argparse.ArgumentParser(description=sys.modules[__name__].__doc__)
  parser.add_argument('--system', action='store_true')
  parser.add_argument('--skip', action='store_true', help='Skip updating Golang')
  args = parser.parse_args()
  if not args.skip:
    if args.system:
      from_binary()
    else:
      from_sources()
  if os.geteuid() != 0:
    # Start getting useful projects right away, if not running as root.
    subprocess.check_call(
        ['go', 'get', '-v',
      'golang.org/x/tools/cmd/godoc',
      'golang.org/x/tools/cmd/goimports',
      'golang.org/x/tools/cmd/stringer',
      'github.com/maruel/panicparse/cmd/pp'])
    # github.com/FiloSottile/gorebuild
  else:
    print('Skipping tooling because running as root')
  return 0


if __name__ == '__main__':
  sys.exit(main())
