#!/usr/bin/osascript -l JavaScript
// Copyright 2022 Marc-Antoine Ruel. All Rights Reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.
//
// Toggle the active front window AXFullScreen attribute.

let system = Application("System Events");
let proc = system.applicationProcesses.whose({frontmost: true})[0];
let front = proc.windows.whose({subrole: 'AXStandardWindow'})[0];
let presentationMode = front.attributes.AXFullScreen;
presentationMode.value = !presentationMode.value();
