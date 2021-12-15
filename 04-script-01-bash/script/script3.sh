#!/bin/bash
ips=(192.168.0.1 173.194.222.113 87.250.250.24)
timeout=5
log=ip_log.log
errorlog=ip_error.log
check='curl -Is --connect-timeout'
for i in {1..5}
do
date>>$log
for host in ${ips[@]}
do
$check $timeout http://$host>/dev/null

if (($? == 0))
then
status="http UP"
echo $host $status>>$log
else
status="http DOWN"
echo $host $status>>$errorlog
exit
fi

done
done
