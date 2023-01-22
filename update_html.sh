#!/bin/bash

Directory="/root/Desktop/logs"
avgFile=$(ls $Directory/averages | grep avg)
avgDate=$(echo $avgFile | grep -oP '_\K\d{4}-\d{2}-\d{2}')
echo $avgDate

diskHtml=$(cat $Directory/averages/$avgFile)
diskHtml=$(echo $diskHtml | sed 's/\\n/<br>/g')

echo -e $diskHtml


#_____________________________________________________________________Read averages into array__________________________________-
# Initialize an array to store the statistics
declare -a statistics=()

while read -r line; do
  # Extract the statistic name and value
  name=$(echo "$line" | awk -F'=' '{print $1}')
  value=$(echo "$line" | awk -F'=' '{print $2}')
  # Extract the number and unit
  number=$(echo "$value" | awk '{print $1}')
  unit=$(echo "$value" | awk '{print $2}')

  # Add the extracted values to the statistics array
  statistics+=("$number $unit")

done < "$Directory/averages/$avgFile"

# Print the statistics array
echo "Statistics: ${statistics[1]}"
#___________________________________________________________

startHtml=$(cat /root/Desktop/htmlStart)

IndexHtml=$(cat /root/Desktop/htmlForIndex)
IndexHtml="$IndexHtml
<h1>Server Stats</h1> 
<h3>Date of Averages: $avgDate </h3>"

DiskHtml="$startHtml
<h1>Server Disk Usage</h1> 
<h3>Disk Usage Avg: ${statistics[2]} <br> Free Disk Space Avg: ${statistics[3]} <br>Date of Averages: $avgDate </h3>"

MemHtml="$startHtml
<h1>Server Memory Usage</h1> 
<<h3>Mem Usage Avg: ${statistics[0]} <br> Free Mem Space Avg: ${statistics[1]} <br>Date of Averages: $avgDate </h3>"


CpuHtml="$startHtml
<h1>Server CPU Usage</h1> 
<h3>Cpu Util Avg: ${statistics[4]} <br> Date of Averages: $avgDate </h3>"

endHtml="</body>
</html>"


#_____________________________________________________________Table for averages____________________________________
table="<table>
  <tr>
    <th>Statistic</th>
    <th>Average Value</th>
  </tr>"

# Read the statistics from the file
while read -r line; do
  # Extract the statistic name and value
  name=$(echo "$line" | awk -F'=' '{print $1}')
  value=$(echo "$line" | awk -F'=' '{print $2}')
  # Add a new row to the table with the statistic name and value
  table="$table
  <tr>
    <td>$name</td>
    <td>$value</td>
  </tr>"
done < /root/Desktop/logs/averages/*

# Close the table
table="$table
</table>"

echo -e "$IndexHtml $table $endHtml" > /stat_web/index.html


#____________________________________________________________Tables for Disk usage_________________________________________________



table="<h2>Used Disk Space </h2>"

for file in ${Directory}/disk_usage*; do
	
	fileDate=$(echo $file | grep -oP '_\K\d{4}-\d{2}-\d{2}_\d{2}')
	table="$table
	<h3>Date of Stats: $fileDate </h3>"

	#file=$(echo $file | sed '1,2d') 
	table="$table
	<table>
	  <tr>
	    <th>Filesystem</th>
	    <th>Size</th>
	    <th>Use%</th>
	  </tr>"
	# Create an empty table
	# Read the statistics from the file
	while read -r line; do
		# Extract the filesystem, size, and usage
		  filesystem=$(echo "$line" | awk '{print $1}')
		  size=$(echo "$line" | awk '{print $2}')
		  usage=$(echo "$line" | awk '{print $3}')
		  # Add a new row to the table with the filesystem, size, and usage
		  table="$table
		  <tr>
		    <td>$filesystem</td>
		    <td>$size</td>
		    <td>$usage</td>
		  </tr>"
	done < $file 

	# Close the table
	table="$table
	</table>"
done





#____________________________________________________________Tables for Free Disk_________________________________________________

table="$table<h2>Free Disk Space </h2>"

for file in ${Directory}/disk_free*; do
	
	fileDate=$(echo $file | grep -oP '_\K\d{4}-\d{2}-\d{2}_\d{2}')
	table="$table
	<h3>Date of Stats: $fileDate </h3>"

	table="$table
	<table>
	  <tr>
	    <th>Filesystem</th>
	    <th>Size</th>
	    <th>Available</th>
	 
	  </tr>"
	# Create an empty table
	# Read the statistics from the file
	while read -r line; do
		# Extract the filesystem, size, and usage
		  filesystem=$(echo "$line" | awk '{print $1}')
		  size=$(echo "$line" | awk '{print $2}')
		  avail=$(echo "$line" | awk '{print $3}')
		  # Add a new row to the table with the filesystem, size, and usage
		  table="$table
		  <tr>
		    <td>$filesystem</td>
		    <td>$size</td>
		    <td>$avail</td>
		  </tr>"
	done < $file 

	# Close the table
	table="$table
	</table>"
done

echo -e "$DiskHtml $table $endHtml" > /stat_web/disk_usage.html


#____________________________________________________________Tables for Used Memory_________________________________________________

table="<h2>Used Memory Space </h2>"

for file in ${Directory}/mem_used*; do
	
	fileDate=$(echo $file | grep -oP '_\K\d{4}-\d{2}-\d{2}_\d{2}')
	table="$table
	<h3>Date of Stats: $fileDate </h3>"

	table="$table
	<table>
	  <tr>
	    <th>Mem Type</th>
	    <th>Total</th>
	    <th>Used</th>
	 
	  </tr>"
	# Create an empty table
	# Read the statistics from the file
	while read -r line; do
		# Extract the filesystem, size, and usage
		  filesystem=$(echo "$line" | awk '{print $1}')
		  size=$(echo "$line" | awk '{print $2}')
		  avail=$(echo "$line" | awk '{print $3}')
		  # Add a new row to the table with the filesystem, size, and usage
		  table="$table
		  <tr>
		    <td>$filesystem</td>
		    <td>$size</td>
		    <td>$avail</td>
		  </tr>"
	done < $file 

	# Close the table
	table="$table
	</table>"
done



#____________________________________________________________Tables for Free Memory_________________________________________________

table="$table<h2>Free Memory Space </h2>"

for file in ${Directory}/mem_free*; do
	
	fileDate=$(echo $file | grep -oP '_\K\d{4}-\d{2}-\d{2}_\d{2}')
	table="$table
	<h3>Date of Stats: $fileDate </h3>"

	table="$table
	<table>
	  <tr>
	    <th>Mem Type</th>
	    <th>Total</th>
	    <th>Free</th>
	 
	  </tr>"
	# Create an empty table
	# Read the statistics from the file
	while read -r line; do
		# Extract the filesystem, size, and usage
		  filesystem=$(echo "$line" | awk '{print $1}')
		  size=$(echo "$line" | awk '{print $2}')
		  avail=$(echo "$line" | awk '{print $3}')
		  # Add a new row to the table with the filesystem, size, and usage
		  table="$table
		  <tr>
		    <td>$filesystem</td>
		    <td>$size</td>
		    <td>$avail</td>
		  </tr>"
	done < $file 

	# Close the table
	table="$table
	</table>"
done

echo -e "$MemHtml $table $endHtml" > /stat_web/memory_usage.html




#____________________________________________________________CPU Utilization_________________________________________________

table="<h2>CPU Utilization </h2>"

for file in ${Directory}/cpu*; do
	
	fileDate=$(echo $file | grep -oP '_\K\d{4}-\d{2}-\d{2}_\d{2}')
	table="$table
	<h3>Date of Stats: $fileDate </h3>"

	table="$table
	<table>
	  <tr>
	    <th>CPU Util</th>
	  </tr>"
	# Create an empty table
	# Read the statistics from the file
	while read -r line; do
		# Extract the filesystem, size, and usage
		  filesystem=$(echo "$line" | awk '{print $1}')
		  # Add a new row to the table with the filesystem, size, and usage
		  table="$table
		  <tr>
		    <td>$filesystem</td>
		  </tr>"
	done < $file 

	# Close the table
	table="$table
	</table>"
done





echo -e "$CpuHtml $table $endHtml" > /stat_web/cpu_usage.html






