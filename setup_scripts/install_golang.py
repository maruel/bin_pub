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


def from_sources(goroot):
  """Installing from sources."""
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

  # TODO(maruel): if go version == git tag, don't build!
  # sudo apt install g++ if missing.
  print('Building.')
  subprocess.check_call(['./make.bash'], cwd=os.path.join(goroot, 'src'))


def from_precompiled(goroot):
  """Installs from pre-built binaries."""
  print('Installing Go in %s' % goroot)
  if os.path.isdir(goroot):
    shutil.rmtree(goroot)
  version = urllib.request.urlopen(
      'https://go.dev/VERSION?m=text').read().decode('utf-8').split('\n', 2)[0]
  uname = os.uname()[4]
  arch = 'amd64'
  if uname.startswith('arm'):
    if sys.maxsize > 2**32:
      arch = 'arm64'
    else:
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
  def reporthook(chunk, size, total):
    sys.stdout.write('%.1f%%\r' % (100. * float(chunk*size)/float(total)))
  filename, _ = urllib.request.urlretrieve(url, reporthook=reporthook)
  sys.stdout.write('\n')
  try:
    print('Extracting to %s' % goroot)
    if not os.path.isdir(goroot):
      os.mkdir(goroot)
    subprocess.check_call(
        ['tar', '-C', goroot, '--strip-components=1', '-xzf', filename])
  finally:
    os.remove(filename)


def setup_profile(goroot):
  """Sets up the global profilet to include system wide Go."""
  with open('/etc/profile.d/golang.sh', 'wb') as f:
    f.write('export PATH="$PATH:%s/bin"\n' % goroot)
  os.chmod('/etc/profile.d/golang.sh', 0o555)


def main():
  parser = argparse.ArgumentParser(description=sys.modules[__name__].__doc__)
  parser.add_argument(
      '--type', choices=('system', 'bootstrap', 'compiled', 'skip'),
      default='compiled' if os.geteuid() else 'system',
      help='Install in /usr/local/go, in ~/go1.4, ~/src/golang or skip')
  parser.add_argument('--bootstrap', action='store_true')
  parser.add_argument(
      '--skip', action='store_true',
      help='Skip updating Golang; only install packages')
  args = parser.parse_args()

  if args.type != 'skip':
    if args.type == 'system':
      goroot = '/usr/local/go'
      from_precompiled(goroot)
      setup_profile(goroot)
    else:
      go14 = os.path.join(os.path.expanduser("~"), "go1.4")
      if args.type == 'bootstrap' or not os.path.isfile(os.path.join(go14, "VERSION")):
        from_precompiled(go14)
      if args.type == 'compiled':
        goroot = (
            os.environ.get('GOROOT') or
            os.path.join(os.path.expanduser('~'), 'src-oth', 'golang'))
        from_sources(goroot)

  if not os.geteuid():
    print('Skipping tooling because running as root')
  elif args.type != 'bootstrap':
    # Start getting useful projects right away, if not running as root.
    go = 'go'
    if goroot:
      go = os.path.join(goroot, 'bin', 'go')
    pkgs = [
      'golang.org/x/tools/cmd/godoc@latest',
      'golang.org/x/tools/cmd/goimports@latest',
      #'golang.org/x/tools/cmd/stringer@latest',
      #'github.com/axw/gocov/gocov',
      'github.com/client9/misspell/cmd/misspell@latest',
      #'github.com/boyter/scc@latest',
      'github.com/maruel/panicparse/v2/cmd/pp@latest',
      'github.com/monochromegane/the_platinum_searcher/cmd/pt@latest',
      #'github.com/rjeczalik/bin/cmd/gobin@latest',
      #'github.com/FiloSottile/gorebuild',
    ]
    for pkg in pkgs:
      subprocess.check_call([go, 'install', '-v', pkg])
  return 0


if __name__ == '__main__':
  sys.exit(main())
