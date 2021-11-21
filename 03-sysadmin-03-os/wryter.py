#!/usr/bin/env python3
# -*- coding: utf-8 -*-


lsof_log = open('lsof.log', 'w')

lsof_m = "message\n"

for i in range(9999999999999999999999999999999999):
    lsof_log.write(lsof_m)

lsof_log.close()
