#!/usr/bin/env python3

import os

bash_command = ["cd /run/media/alexandr/Data/DevOps/DevOps-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('изменено:   ', '')
        print(prepare_result)