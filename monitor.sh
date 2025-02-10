#!/bin/bash

# Define threshold values
CPU_THRESHOLD=80  # Percentage
MEM_THRESHOLD=80  # Percentage
DISK_THRESHOLD=90 # Percentage

# Log file
LOG_FILE="/var/log/system_monitor.log"

# Email alert function
send_alert() {
    SUBJECT="$1"
    MESSAGE="$2"
    echo -e "$MESSAGE" | mail -s "$SUBJECT" your_email@example.com
}

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
CPU_INT=${CPU_USAGE%.*} # Convert to integer

if [[ "$CPU_INT" -gt "$CPU_THRESHOLD" ]]; then
    ALERT_MSG="Warning: High CPU usage detected! Current: ${CPU_INT}%"
    echo "$(date): $ALERT_MSG" >> "$LOG_FILE"
    send_alert "CPU Alert" "$ALERT_MSG"
fi

# Check Memory usage
MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100.0}')
if [[ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]]; then
    ALERT_MSG="Warning: High Memory usage detected! Current: ${MEM_USAGE}%"
    echo "$(date): $ALERT_MSG" >> "$LOG_FILE"
    send_alert "Memory Alert" "$ALERT_MSG"
fi

# Check Disk usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [[ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]]; then
    ALERT_MSG="Warning: High Disk usage detected! Current: ${DISK_USAGE}%"
    echo "$(date): $ALERT_MSG" >> "$LOG_FILE"
    send_alert "Disk Alert" "$ALERT_MSG"
fi

# Append summary to log
echo "$(date): CPU=${CPU_INT}%, MEM=${MEM_USAGE}%, DISK=${DISK_USAGE}%" >> "$LOG_FILE"

