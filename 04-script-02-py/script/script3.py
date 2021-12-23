#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import time
import ast

url = ['drive.google.com', 'mail.google.com', 'google.com']
ip = []


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
        ips = []
    return ips


while True:
    for n in range(len(url)):
        ips = IPhost(url[n])
        # print(repr(url[n]+' '+ips))
        # dict_ip = ("{} {}".format(url[n], ips))
        dict_ip = (url[n]+' - '+ips)
        print(dict_ip)
    time.sleep(5)

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
