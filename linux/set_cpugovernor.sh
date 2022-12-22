#!/bin/sh

set -eu

if [ "$#" != 1 ]; then
  echo "usage: sudo ./set_cpugovernor.sh [powersave|performance]"
  exit 1
fi

echo "Was: $(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | uniq)"

for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo $1 > $i
done

echo "Now: $(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | uniq)"
