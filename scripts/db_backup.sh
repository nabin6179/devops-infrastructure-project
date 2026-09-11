#!/bin/bash

BACKUP_DIR="/var/backups/db"
DATE=$(date '+%Y%m%d')
BACKUP_FILE="$BACKUP_DIR/db_backup_${DATE}.sql.gz"

docker exec task2-db pg_dump -U task2user -d task2db | gzip > "$BACKUP_FILE"

echo "Database backup created: $BACKUP_FILE"
