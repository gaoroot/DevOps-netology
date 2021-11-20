#/usr/bin/env python3
#coding:utf-8

from multiprocessing import Process
import time,os

def run():
    print("Ребёнок", os.getpid())

if __name__ == '__main__':
    p=Process(target=run)
    p.start()

    print("Родитель",os.getpid())
    time.sleep(1000)
