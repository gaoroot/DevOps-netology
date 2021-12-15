#!/bin/bash
while ((1==1))
do
curl http://localhost
if (($? != 0))
then
date >> curl.log
sleep 1
else exit
fi
done