#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=100  # Example process threshold, you can adjust it as needed

# Function to check CPU usage
check_cpu_usage() {
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
             sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
             awk '{print 100 - $1}')
  if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "Alert: CPU usage is above threshold! Current usage: $CPU_USAGE%"
  fi
}

# Function to check memory usage
check_memory_usage() {
  MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    echo "Alert: Memory usage is above threshold! Current usage: $MEM_USAGE%"
  fi
}

# Function to check disk space usage
check_disk_usage() {
  DISK_USAGE=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//g')
  if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "Alert: Disk space usage is above threshold! Current usage: $DISK_USAGE%"
  fi
}

# Function to check running processes
check_processes() {
  PROCESS_COUNT=$(ps aux | wc -l)
  if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    echo "Alert: Number of running processes is above threshold! Current count: $PROCESS_COUNT"
  fi
}

# Main function to run all checks
main() {
  check_cpu_usage
  check_memory_usage
  check_disk_usage
  check_processes
}

# Run the main function
main

# Optionally, you can add a cron job to run this script periodically
# For example, to run every 5 minutes, add the following line to your crontab (crontab -e):
# */5 * * * * /path/to/your_script.sh >> /path/to/log_file.log 2>&1
