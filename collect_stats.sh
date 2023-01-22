current_timestamp=$(date +%Y-%m-%d_%H)
echo "Current timestamp is $current_timestamp"



if [ "$1" != "test" ];
then
	df | awk '{sum+=$3} END {print sum/(1024*1024)}' > /root/Desktop/logs/disk_usage_$current_timestamp
	df -h | awk '{printf " %-10s %-10s %s\n", $1, $2, $5}' >> /root/Desktop/logs/disk_usage_$current_timestamp

	df | awk '{sum+=$4} END {print sum/(1024*1024)}' > /root/Desktop/logs/disk_free_$current_timestamp
	df -h | awk '{printf " %-10s %-10s %-10s %s\n", $1, $2, $4, 100-$5}' >> /root/Desktop/logs/disk_free_$current_timestamp

	echo "type $(free -m)" | awk '{printf " %-10s %-10s %s\n", $1, $2, $3}' > /root/Desktop/logs/mem_used_$current_timestamp

	echo "type $(free -m)" | awk '{printf " %-10s %-10s %s\n", $1, $2, $4}' > /root/Desktop/logs/mem_free_$current_timestamp

	top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' > /root/Desktop/logs/cpu_util_$current_timestamp
else
	df | awk '{sum+=$3} END {print sum/(1024*1024)}'
	df -h | awk '{printf " %-10s %-10s %s\n", $1, $2, $5}'
	echo "\n"

	df | awk '{sum+=$4} END {print sum/(1024*1024)}'
	df -h | awk '{printf " %-10s %-10s %-10s %s\n", $1, $2, $4, 100-$5}' 
	echo "\n"

	echo "type $(free -m)" | awk '{printf " %-10s %-10s %s\n", $1, $2, $3}'
	echo "\n"

	echo "type $(free -m)" | awk '{printf " %-10s %-10s %s\n", $1, $2, $4}' 
	echo "\n"

	top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' 
fi
