#!/bin/bash

# Set the end time
end_time=$(( $(date +%s) + 600 ))

# Loop until the current time is greater than the end time
while [[ $(date +%s) -le $end_time ]]; do
  # Print the current time
  date

  # Sleep for 60 seconds
  sleep 1
done

echo "Done!"

