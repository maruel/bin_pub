#!/usr/bin/env python3
# Copyright 2021 Marc-Antoine Ruel. All Rights Reserved. Use of this
# source code is governed by a BSD-style license that can be found in the
# LICENSE file.

P = '/sys/class/power_supply/BAT0/'

# Battery voltage. Impacted by charging.
with open(P+ 'voltage_now', 'r') as f:
	voltage = int(f.read()) / 1000000.0

# Energy in the battery.
with open(P+ 'energy_now', 'r') as f:
	energy = int(f.read()) / 1000000.0

# Power being handled by the power supply inside the laptop (FWIU).
with open(P+ 'power_now', 'r') as f:
	power = int(f.read()) / 1000000.0

print('{0:.2f}W {1:.2f}Wh {2:.2f}V'.format(power, energy, voltage))
