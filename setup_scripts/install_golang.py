#!/usr/bin/env python3
# Copyright 2016 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

import argparse
import ctypes
import os
import shutil
import subprocess
import tarfile
import sys
import urllib.request
import zipfile


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
  print('Building.')
  env = os.environ.copy()
  if sys.platform == 'win32':
    # GOROOT_BOOTSTRAP may be set to C:\\Program Files\\Go if Go was installed
    # with the MSI package. We want to use the version we control.
    env['GOROOT_BOOTSTRAP'] = os.path.expanduser('~\\go1.4')
    print(env['GOROOT_BOOTSTRAP'])
    cmd = ['cmd.exe', '/c', 'make.bat']
  else:
    # sudo apt install g++ if missing.
    cmd = ['./make.bash']
  try:
    subprocess.check_call(cmd, cwd=os.path.join(goroot, 'src'), env=env)
  except (OSError, subprocess.CalledProcessError) as e:
    print('Failed to run', cmd, e)
    sys.exit(1)


def from_precompiled(goroot):
  """Installs from pre-built binaries."""
  print('Installing Go in %s' % goroot)
  if os.path.isdir(goroot):
    shutil.rmtree(goroot)
  version = urllib.request.urlopen(
      'https://go.dev/VERSION?m=text').read().decode('utf-8').split('\n', 2)[0]
  arch = 'amd64'
  if sys.platform != 'win32':
    uname = os.uname()[4]
    if uname.startswith('arm'):
      if sys.maxsize > 2**32:
        arch = 'arm64'
      else:
        # ~70MB, at 1Mbit it takes 12 minutes...
        arch = 'armv6l'

  os_name = sys.platform
  ext = '.tar.gz'
  if os_name == 'linux2':
    os_name = 'linux'
  elif os_name == 'win32':
    os_name = 'windows'
    ext = '.zip'
  filename = version + '.' + os_name + '-' + arch + ext
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
    # We have to skip the go/ prefix.
    if sys.platform == 'win32':
      with zipfile.ZipFile(filename) as z:
        for i in z.infolist():
          if i.is_dir():
            continue
          assert i.filename.startswith('go/'), i.filename
          i.filename = i.filename[3:]
          z.extract(i, goroot)
    else:
      subprocess.check_call(
          ['tar', '-C', goroot, '--strip-components=1', '-xzf', filename])
  finally:
    os.remove(filename)


def setup_user_profile(goroot):
  """Sets up the user profile to include our local Go."""
  if sys.platform == 'win32':
    append_path_windows(os.path.join(goroot, 'bin'), user=True)
    gopathbin = os.path.join(os.environ.get("GOPATH", os.path.expanduser('~\\go')), "bin")
    append_path_windows(gopathbin, user=True)
    broadcast_windows_settings()
  else:
    # This is done by .bash_aliases
    pass


def setup_system_profile(goroot):
  """Sets up the global profile to include system wide Go."""
  if sys.platform == 'win32':
    append_path_windows(os.path.join(goroot, 'bin'), user=False)
    gopathbin = os.path.join(os.environ.get("GOPATH", os.path.expanduser('~\\go')), "bin")
    append_path_windows(gopathbin, user=False)
    broadcast_windows_settings()
  else:
    with open('/etc/profile.d/golang.sh', 'wb') as f:
      f.write('export PATH="$PATH:%s/bin"\n' % goroot)
    os.chmod('/etc/profile.d/golang.sh', 0o555)


def append_path_windows(directory, user):
  """Append a path to %PATH% if not already present."""
  import winreg
  if user:
    reg_key = winreg.OpenKey(
        winreg.HKEY_CURRENT_USER, 'Environment', 0,
        winreg.KEY_QUERY_VALUE|winreg.KEY_SET_VALUE)
  else:
    reg_key = winreg.OpenKey(
        winreg.HKEY_LOCAL_MACHINE,
        'SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment',
        0, winreg.KEY_QUERY_VALUE|winreg.KEY_SET_VALUE)
  with reg_key:
    val, t = winreg.QueryValueEx(reg_key, 'PATH')
    if t != winreg.REG_EXPAND_SZ:
      print('Unexpected PATH registry type')
      sys.exit(1)
    if directory.lower() in [p for p in val.lower().split(';')]:
      return
    val = val.rstrip(';') + ';' + directory
    winreg.SetValueEx(reg_key, 'PATH', 0, winreg.REG_EXPAND_SZ, val)


def broadcast_windows_settings():
  """Tells all apps that environment variables were updated.

  Call SendMessageTimeout directly to send broadcast to all windows
  without depending on win32con/win32gui.
  """
  from ctypes import wintypes
  SendMessageTimeout = ctypes.windll.user32.SendMessageTimeoutW
  UINT = wintypes.UINT
  SendMessageTimeout.argtypes = (
    wintypes.HWND, UINT, wintypes.WPARAM, ctypes.c_wchar_p, UINT, UINT,
    wintypes.LPDWORD)
  SendMessageTimeout.restype = wintypes.LPARAM
  HWND_BROADCAST = 0xFFFF
  WM_SETTINGCHANGE = 0x1A
  SMTO_ABORTIFHUNG = 0x2
  SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, 'Environment',
      SMTO_ABORTIFHUNG, 5000, None)


def main():
  is_root = False
  if sys.platform != 'win32':
    is_root = not bool(os.geteuid())
  parser = argparse.ArgumentParser(description=sys.modules[__name__].__doc__)
  parser.add_argument(
      '--type', choices=('system', 'bootstrap', 'compiled', 'skip'),
      default='compiled' if not is_root else 'system',
      help='Install in /usr/local/go, in ~/go1.4, ~/src-oth/golang or skip')
  parser.add_argument('--bootstrap', action='store_true')
  parser.add_argument(
      '--skip', action='store_true',
      help='Skip updating Golang; only install packages')
  args = parser.parse_args()

  if args.type != 'skip':
    if args.type == 'system':
      if sys.platform == 'win32':
        print('Not yet supported')
        return 1
      goroot = '/usr/local/go'
      from_precompiled(goroot)
      setup_system_profile(goroot)
    else:
      go14 = os.path.join(os.path.expanduser("~"), "go1.4")
      if args.type == 'bootstrap' or not os.path.isfile(os.path.join(go14, "VERSION")):
        from_precompiled(go14)
      if args.type == 'compiled':
        if sys.platform == 'win32' and os.path.exists('s:\\'):
            goroot = 's:\\src-oth\\golang'
        else:
          goroot = (
              os.environ.get('GOROOT') or
              os.path.join(os.path.expanduser('~'), 'src-oth', 'golang'))
        from_sources(goroot)
        setup_user_profile(goroot)
  else:
    if sys.platform == 'win32' and os.path.exists('s:\\'):
        goroot = 's:\\src-oth\\golang'
    else:
      goroot = (
          os.environ.get('GOROOT') or
          os.path.join(os.path.expanduser('~'), 'src-oth', 'golang'))

  if is_root:
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
