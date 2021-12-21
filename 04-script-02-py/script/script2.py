#!/usr/bin/env python3

import os
import sys


cmd = os.getcwd()

if len(sys.argv)>=2:
    cmd = sys.argv[1]
bash_command = ["cd "+cmd, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('fatal') != -1:
        print(cmd+" git не найден")
    if result.find('изменено') != -1:
        prepare_result = result.replace('\изменено:   ', '')
        print(prepare_result)



# import sys

# if len (sys.argv) > 1:
#     print ("Привет, {}!".format (sys.argv[1] ) )
# else:
#     print ("Привет, мир!")