#!/bin/bash
if [ $IGNORE_COMPRESSION == true ]; then
    ignore_compression_flag = "--checkCompr"
else
    ignore_compression_flag = ""
fi
storebackup_options=--sourceDir /data/source/ \
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
    $ignore_compression_flag \
    --verbose
echo "INFO      $(date '+%Y.%m.%d %H:%M:%S')     # Print Options"
bin/storeBackup.pl --print $storebackup_options
echo "INFO      $(date '+%Y.%m.%d %H:%M:%S')     # Started Backup"
while [ true ]; do
    bin/storeBackup.pl $storebackup_options
    current_epoch=$(date +%s.%N)
    target_epoch=$(date -d 'tomorrow 00:00' +%s)
    sleep_seconds=$(echo "$target_epoch - $current_epoch" | bc)
    echo "INFO      $(date '+%Y.%m.%d %H:%M:%S')     # Goodnight i will sleep until tomorrow ($sleep_seconds secs)"
    sleep $sleep_seconds
    if $? -eq 0; then
        echo "INFO      $(date '+%Y.%m.%d %H:%M:%S')     # Good Morning, i will start with the backup now!"
    else
        echo "ERROR     $(date '+%Y.%m.%d %H:%M:%S')     # Exit now, sleep was aborted"
        exit 0
    fi
done
