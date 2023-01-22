#!/bin/bash


today=$(date +%Y-%m-%d)



# Define the prefix of the files to be read
file_prefix="/root/Desktop/logs/mem_used"

# Change to the target directory
#cd "$directory"

# Loop through all files that start with the specified prefix
set num=0
set current=0
set sum=0
set avg=0
for file in $file_prefix*; do
    num=$((num+1))
    echo "Processing file: $file"
    current=$(cat $file |sed -n 2p | awk '{printf"%d", $3}') 
    sum=$((sum+current))
done

avg=$(( sum/num ))
echo "Average memory used = $avg MB\n" > /root/Desktop/logs/averages/avg_$today



file_prefix="/root/Desktop/logs/mem_free"

num=0
current=0
sum=0
avg=0
for file in $file_prefix*; do
    num=$((num+1))
    echo "Processing file: $file"
    current=$(cat $file |sed -n 2p | awk '{printf"%d", $3}') 
    sum=$((sum+current))
done

avg=$(( sum/num ))
echo "Average memory free = $avg MB\n" >> /root/Desktop/logs/averages/avg_$today





file_prefix="/root/Desktop/logs/disk_usage"

num=0
current=0
sum=0
avg=0
for file in $file_prefix*; do
    num=$((num+1))
    echo "Processing file: $file"
    current=$(cat $file |sed -n 1p | awk '{printf"%s", $1}') 
    sum=$(awk '{print $1+$2}' <<<"${sum} ${current}")
done

avg=$(awk '{print $1/$2}' <<<"${sum} ${num}")
echo "Average Disk space used = $avg GB\n" >> /root/Desktop/logs/averages/avg_$today




file_prefix="/root/Desktop/logs/disk_free"

num=0
current=0
sum=0
avg=0
for file in $file_prefix*; do
    num=$((num+1))
    echo "Processing file: $file"
    current=$(cat $file |sed -n 1p | awk '{printf"%s", $1}') 
    sum=$(awk '{print $1+$2}' <<<"${sum} ${current}")
done

avg=$(awk '{print $1/$2}' <<<"${sum} ${num}")
echo "Average Disk space free = $avg GB\n" >> /root/Desktop/logs/averages/avg_$today




file_prefix="/root/Desktop/logs/cpu"

num=0
current=0
sum=0
avg=0
for file in $file_prefix*; do
    num=$((num+1))
    echo "Processing file: $file"
    current=$(cat $file |sed -n 1p | awk '{printf"%s", $1}') 
    sum=$(awk '{print $1+$2}' <<<"${sum} ${current}")
done

avg=$(awk '{print $1/$2}' <<<"${sum} ${num}")
echo "Average CPU utilization = $avg%\n" >> /root/Desktop/logs/averages/avg_$today

rm /root/Desktop/logs/*$today*

