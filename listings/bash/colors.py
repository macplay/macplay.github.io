#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# FILE: "/home/joze/colors.py"
# LAST MODIFICATION: "Di, 21 Mär 2006 17:02:41 CET (joze)"
# Copyright (C) 2006 by Johannes Zellner, <address@hidden>
# $Id:$

import sys
import os

def echo(msg):
	os.system('echo -n "' + str(msg) + '"')

def out(n):
	os.system("tput setab " + str(n) + "; echo -n " + ("\"% 4d\"" % n))
	os.system("tput setab 0")

# normal colors 1 - 16
for n in range(16):
	out(n)

echo("\n")
echo("\n")

# first three 6 x 6 color layers
#
for y in range(6):

	for z in range(3):

		for x in range(6):

			n = 16 + z * 36 + y * 6 + x
			out(n)

		echo(" ")

	echo("\n")

echo("\n")

# second three 6 x 6 color layers
#
for y in range(6):

	for z in range(3, 6):

		for x in range(6):

			n = 16 + z * 36 + y * 6 + x
			out(n)

		echo(" ")

	echo("\n")

echo("\n")

# gray, first line
for n in range(232, 244):
	out(n)

echo("\n")

# gray, second line
for n in range(244, 256):
	out(n)

echo("\n")
