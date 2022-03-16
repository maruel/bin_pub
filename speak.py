#!/usr/bin/env python3
# Copyright 2022 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

import sys
# https://github.com/pndurette/gTTS
# https://gtts.readthedocs.io/en/latest/
from gtts import gTTS

if not (1 < len(sys.argv) < 4):
  print('Usage: python3.py "words" [lang]')
  sys.exit(1)

word = sys.argv[1]
lang = sys.argv[2] if len(sys.argv) > 2 else 'en'
tld = 'ca'
filename = '%s_%s_%s.mp3' % (
    word.replace(' ', '_'), lang, (tld if tld != 'com' else 'us').upper())

gTTS(word, lang=lang, tld=tld).save(filename)
