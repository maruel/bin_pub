#!/bin/sh
# Copyright 2012 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.
echo "Installing Go"
hg clone https://code.google.com/p/go/ -r go1.0.3 $HOME/src/golang
cd $HOME/src/golang/src
./all.bash
