#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import time

servers = {"drive.google.com": "", "mail.google.com": "", "google.com": ""}

while True:
    for url, ip in servers.items():
        ip_addr = socket.gethostbyname(url)
        if ip == "":
            servers[url] = ip_addr
            print("{} - {}".format(url, ip_addr))
        if ip != ip_addr:
            servers[url] = ip_addr
            print("[ERROR] {} IP mismatch: {} -> {}".format(url, ip, ip_addr))

    # time.sleep(1)