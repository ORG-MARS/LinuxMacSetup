#!/usr/bin/env python
#coding=utf-8
"""
Author:         suzukaze hazuki <suzukaze.hazuki2020@gmail.com>
Filename:       gip
Date created:   2021-07-29 10:29
Last modified:  2021-07-29 10:41
Modified by:    suzukaze hazuki <suzukaze.hazuki2020@gmail.com>

Description:
    grep ipaddress from stdin, write to stdout
Changelog:
"""
import re
import sys

ipaddr_re = re.compile(r'(\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b)')

for line in sys.stdin.readlines():
    if ipaddr_re.match(line):
        content = ' '.join(obj.group() for obj in ipaddr_re.finditer(line))
        sys.stdout.write("%s\n" % content)
