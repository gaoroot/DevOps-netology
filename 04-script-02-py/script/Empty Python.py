#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket

def get_ips_for_host(host):
        try:
            ips = socket.gethostbyname(host)
        except socket.gaierror:
            ips=[]
        return ips

def get_ips_for_host2(host):
        try:
            ips = socket.gethostbyname(host)
        except socket.gaierror:
            ips=[]
        return ips

ips = get_ips_for_host('www.google.com')
print(repr(ips))


ips2 = get_ips_for_host2('www.google.com')
print(repr(ips2))

if ips != ips2:
    print('ERROR '+ips+' -> '+ips2)