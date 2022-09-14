#!/usr/bin/osascript -l JavaScript
// Copyright 2022 Marc-Antoine Ruel. All Rights Reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.
//
// This file contains useful functions to help exploring the macOS automation
// system because let's be real, it's a mess.

// Returns the name of a "query object" if possible, otherwise the display name.
//
// There's a risk that the display string will be a query.
const getName = (obj) => {
  return (obj.name === undefined) ? Automation.getDisplayString(obj) : obj.name();
}

// Lists all the object properties.
//
// Super useful.
const logProperties = (obj) => {
  console.log("Properties of " + getName(obj) + ":");
  let props = obj.properties();
  let names = Object.keys(props).sort();
  for (let key in names) {
    let i = names[key];
    console.log("- " + i + ": " + Automation.getDisplayString(props[i]));
  }
}

// Lists all the object attributes.
//
// Super useful.
const logAttributes = (obj) => {
  console.log("Attributes of " + getName(obj) + ":");
  let attr = obj.attributes();
  let keys = Object.keys(attr);
  let names = [];
  for (let key in keys) {
    names.push(attr[key].name());
  }
  names.sort();
  for (let i in names) {
    let key = names[i];
    console.log("- " + key + ": " + Automation.getDisplayString(obj.attributes.byName(key).value()));
  }
}

// Lists all the JavaScript fields.
//
// It is not super useful because everything is "late-bound".
const getFields = (obj) => {
  let properties = new Set();
  let currentObj = obj;
  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item));
  } while (currentObj = Object.getPrototypeOf(currentObj));
  return [...properties.keys()].sort();
}

// Lists all the JavaScript fields.
//
// It is not super useful because everything is "late-bound".
const logFields = (obj) => {
  console.log("JavaScript fields of " + getName(obj) + ":");
  let attr = getFields(obj);
  for (let item in attr) {
    let t = typeof obj[attr[item]];
    if (t === 'function') {
      console.log("- " + attr[item] + "()");
    } else if (t === 'object') {
      console.log("- " + attr[item]);
    } else {
      console.log("- " + attr[item] + "   " + t);
    }
  }
}


let system = Application("System Events");
logFields(system);
console.log("");
logProperties(system);
// system doesn't have attributes.

let proc = system.applicationProcesses.whose({frontmost: true})[0];
console.log("Frontmost process is: " + proc.displayedName());

let front = proc.windows.whose({subrole: 'AXStandardWindow'})[0];
console.log("Active windows is: " + front.properties().name);

console.log("");
logFields(front);

console.log("");
logProperties(front);

console.log("");
logAttributes(front);
