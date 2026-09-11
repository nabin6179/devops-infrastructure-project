#!/bin/bash

LOG_FILE="/var/log/infra_health.log"
APP_CONTAINER="task2-backend"
TIME=$(date '+%Y-%m-%d %H:%M:%S')

echo "===== Infrastructure Health Check ====="
echo "Time: $TIME"

# CPU usage
CPU=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')
echo "CPU Usage: $CPU%"

# RAM usage
RAM=$(free | awk '/Mem:/ {printf "%.1f", ($3/$2)*100}')
echo "RAM Usage: $RAM%"

# Disk usage
DISK=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
echo "Disk Usage: $DISK%"

# Docker status
if systemctl is-active --quiet docker; then
    echo "Docker: RUNNING"
else
    echo "Docker: STOPPED"
fi

# Application container status
if docker inspect -f '{{.State.Running}}' "$APP_CONTAINER" 2>/dev/null | grep -q true; then
    echo "Application Container: RUNNING"
else
    echo "Application Container: STOPPED"
    echo "[WARNING] Application container is stopped."
    echo "[$TIME] [WARNING] Application container is stopped." >> "$LOG_FILE"
fi

# Disk warning
if [ "$DISK" -gt 85 ]; then
    echo "[WARNING] Disk usage is above 85%."
    echo "[$TIME] [WARNING] Disk usage is ${DISK}%." >> "$LOG_FILE"
fi

echo "========================================"

