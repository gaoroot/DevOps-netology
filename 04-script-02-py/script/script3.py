#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import time

url = ['drive.google.com', 'mail.google.com', 'google.com']

# while 1==1:
#     for n in range(len(url)):
#         ip = socket.gethostbyname(url[n])
#         print(url[n]+' '+ip)
#         ip2 = ip
#         if ip != ip2:
#             print('ERROR'+ip+' '+ip2)
#     time.sleep(1)
#     print()


def IPhost(host):
        try:
            ips = socket.gethostbyname(host)
        except socket.gaierror:
            ips=[]
        return ips

for n in range(len(url)):
    ips = IPhost(url[n])
    # print(repr(url[n]+' '+ips))
    print("{} - {}".format(url[n], ips))


# if ips != ips2:
#     print("[ERROR] {} - {}".format(url[n],''+ips+' -> ' +ips2))


# while 1==1:
#     for n in range(len(url)):
#         ip = socket.gethostbyname(url[n])
#         print("{} - {}".format(url[n], ip))
#         # if ip != ip2:
#         #     print(ERROR)
#     time.sleep(1)
#     print()


