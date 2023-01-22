#!/bin/bash

date | awk '{printf "_______________   %-10s %-10s %s   _______________ \n", $2, $3, $6}' >> /root/Desktop/userlog
 w | sed '1,2d' | awk '{ printf "%-10s %-10s \n", $1, $4 }' >> /root/Desktop/userlog

