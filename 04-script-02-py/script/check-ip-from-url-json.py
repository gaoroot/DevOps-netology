#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import socket
import time

# while True:
with open('srv.json') as json_file:
    data = json.load(json_file)
    for url in data['servers']:
        urls = url['url']
        # print('----url from json----')
        print(urls)

    for ip in data['servers']:
        ips = ip['ip']
        # print('----ip from json----')
        print(ips)

    for ipurl in data['servers']:
        # print(urls)
        ipurls = socket.gethostbyname(ipurl['url'])
        # print(ipurls)

        if ips == ipurls:
            data['url'] = ipurls
            print("{} - {}".format(urls, ipurls))
        elif ips != ipurls:
            print("[ERROR] {} IP mismatch: {} -> {}".format(urls, ips, ipurls))
            data['url'] = ipurls
    # time.sleep(1)