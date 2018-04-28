#!/bin/bash
cd storeBackup/bin/
echo "[---] Started Backup"

while [ true ]; do
    storeBackup.pl \
    --sourceDir /data/source/ \
    --backupDir /data/destination/ \
    --series $SERIES_NAME \
    --compress 'gzip -9' \
    --keepAll $BACKUP_DURATION \
    --keepFirstOfWeek $BACKUP_DURATION_FIRST_OF_WEEK \
    --keepFirstOfMonth $BACKUP_DURATION_FIRST_OF_MONTH \
    --keepDuplicate $BACKUP_DURATION_DUPLICATES \
    --keepMinNumber $BACKUP_MIN_NUMBER \
    --keepMaxNumber $BACKUP_MAX_NUMBER \
    --progressReport 1000,1m \
    --printDepth \
    --verbose

    current_epoch=$(date +%s.%N)
    target_epoch=$(date -d 'tomorrow 00:00' +%s)
    sleep_seconds=$(echo "$target_epoch - $current_epoch" | bc)
    echo "[---] Goodnight i will sleep until tomorrow ($sleep_seconds secs)"
    sleep $sleep_seconds
done