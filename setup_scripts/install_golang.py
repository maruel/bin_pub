#!/usr/bin/env python3
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

import argparse
import os
import shutil
import subprocess
import tarfile
import sys
import urllib.request


def _semver(v):
  v = v.split('.')
  for i in range(len(v)):
    try:
      v[i] = int(v[i])
    except ValueError:
      pass
  return v


def _check_output(*args, **kwargs):
  if sys.version_info.major == 3:
    kwargs['universal_newlines'] = True
  return subprocess.check_output(*args, **kwargs)


def from_sources():
  """Installing from sources."""
  home = os.path.expanduser('~')
  goroot = os.environ.get('GOROOT')
  if not goroot:
    goroot = os.path.join(home, 'src', 'golang')
  print('Installing Go in %s' % goroot)
  if os.path.isdir(goroot):
    subprocess.check_call(['git', 'fetch', '--all'], cwd=goroot)
  else:
    subprocess.check_call(
        ['git', 'clone', 'https://go.googlesource.com/go', goroot])

  # Equivalent of:
  #TAG="$(git tag | grep "^go" | egrep -v "beta|rc" | tail -n 1)"
  tags = _check_output(['git', 'tag'], cwd=goroot).splitlines()
  tags = sorted(
      (t for t in tags
      if t.startswith('go') and 'beta' not in t and 'rc' not in t),
      key=_semver)
  tag = tags[-1]
  print('Using %s' % tag)
  subprocess.check_call(['git', 'checkout', tag], cwd=goroot)

  go14 = os.path.join(home, 'go1.4')
  if not os.path.isdir(go14):
    from_precompiled(go14)

  print('Building.')
  subprocess.check_call(['./make.bash'], cwd=os.path.join(goroot, 'src'))


def from_precompiled(goroot):
  """Installs from pre-built binaries."""
  print('Installing Go in %s' % goroot)
  if os.path.isdir(goroot):
    shutil.rmtree(goroot)
  version = urllib.request.urlopen(
      'https://golang.org/VERSION?m=text').read().decode('utf-8')
  uname = os.uname()[4]
  arch = 'amd64'
  if uname.startswith('arm'):
    # ~70MB, at 1Mbit it takes 12 minutes...
    arch = 'armv6l'

  os_name = sys.platform
  if os_name == 'linux2':
    os_name = 'linux'
  filename = version + '.' + os_name + '-' + arch + '.tar.gz'
  # Used to be:
  # url = 'https://storage.googleapis.com/golang/' + filename
  url = 'https://dl.google.com/go/' + filename
  print('Fetching %s' % url)
  subprocess.check_call(['wget', url])
  if not os.path.isdir(goroot):
    os.mkdir(goroot)
  subprocess.check_call(['tar', '-C', goroot, '--strip-components=1', '-xzf', filename])
  os.remove(filename)


def setup_profile(goroot):
  """Sets up the global profilet to include system wide Go."""
  with open('/etc/profile.d/golang.sh', 'wb') as f:
    f.write('export PATH="$PATH:%s/bin"\n' % goroot)
  os.chmod('/etc/profile.d/golang.sh', 0o555)


def main():
  parser = argparse.ArgumentParser(description=sys.modules[__name__].__doc__)
  parser.add_argument('--system', action='store_true')
  parser.add_argument('--skip', action='store_true', help='Skip updating Golang')
  args = parser.parse_args()
  if not args.skip:
    if args.system:
      goroot = '/usr/local/go'
      from_precompiled(goroot)
      setup_profile(goroot)
    else:
      from_sources()
  if os.geteuid() != 0:
    # Start getting useful projects right away, if not running as root.
    subprocess.check_call(
        ['go', 'get', '-v',
      'golang.org/x/tools/cmd/godoc',
      'golang.org/x/tools/cmd/goimports',
      'golang.org/x/tools/cmd/stringer',
      'github.com/boyter/scc@v2',
      'github.com/maruel/panicparse/v2/cmd/pp',
      'github.com/monochromegane/the_platinum_searcher/cmd/pt@v2',
      'github.com/rjeczalik/bin/cmd/gobin',
      #'github.com/FiloSottile/gorebuild',
      ])
  else:
    print('Skipping tooling because running as root')
  return 0


if __name__ == '__main__':
  sys.exit(main())
