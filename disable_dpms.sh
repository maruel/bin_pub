#!/bin/bash
# Crappy hack to disable DMPS off on monitors due to a bug in nvidia driver on
# linux when using 3 monitors.

set -eu

xset s noblank
