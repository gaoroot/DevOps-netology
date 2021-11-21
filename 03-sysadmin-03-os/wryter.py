#!/usr/bin/env python3
# -*- coding: utf-8 -*-


my_file = open('lsof.log', 'w')

text_for_file = "message\n"

for i in range(9999999999999999999999999999999999):
    my_file.write(text_for_file)

my_file.close()
