#! /usr/bin/env python
# -*- coding: utf-8 -*-
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

# Tool for interacting with kde's clipboard, may move to more general soln if I ever leave the KDE train
# Grabbed from https://gist.githubusercontent.com/aeris/3308963/raw/b479e8180e5132ed93923a8fddc1b1cc19878243/clip.py
#           on [2017-03-28 Tue]

import argparse, dbus, sys
bus = dbus.SessionBus()
klipper = bus.get_object('org.kde.klipper', '/klipper')
klipper = dbus.Interface(klipper, dbus_interface='org.kde.klipper.klipper')

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--item", type=int, nargs="?", const=0,
	help="get the Nth item in clipboard history", metavar="N")
parser.add_argument("-x", "--clear", action="store_true", default=False,
	help="clear the clipboard history")
parser.add_argument("args", nargs="?")

args = parser.parse_args()

if args.clear:
	klipper.clearClipboardHistory()
elif args.item is not None:
	sys.stdout.write(klipper.getClipboardHistoryItem(args.item))
else:
	if not args.args:
		content = sys.stdin.read()
	else:
		file = open(args.args, "r")
		content = file.read()
		file.close()
	klipper.setClipboardContents(content)
