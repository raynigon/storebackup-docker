#!/bin/bash

function log {
    echo "$1     $(date '+%Y.%m.%d %H:%M:%S')     # $2"
}

# Write the configuration
cat <<EOF > config.cfg
sourceDir=/data/source/
backupDir=/data/destination/
# Series
includeDirs=
exceptRule=
includeRule=
compress=gzip -9
autorepair=yes
checkBlocksParallel=yes
addExceptSuffix=
noCopy=10
deleteNotFinishedDirs=yes
# Keep Configuration
withUserGroupStat=yes
writeExcludeLog=yes
verbose=yes
progressReport=1000,1m
printDepth=yes
EOF

echo "series=$SERIES_NAME" >> config.cfg
echo "keepAll=$BACKUP_DURATION" >> config.cfg
echo "keepFirstOfWeek=$BACKUP_DURATION_FIRST_OF_WEEK" >> config.cfg
echo "keepFirstOfMonth=$BACKUP_DURATION_FIRST_OF_MONTH" >> config.cfg
echo "keepDuplicate=$BACKUP_DURATION_DUPLICATES" >> config.cfg
echo "keepMinNumber=$BACKUP_MIN_NUMBER" >> config.cfg
echo "keepMaxNumber=$BACKUP_MAX_NUMBER" >> config.cfg
echo "exceptDirs=$EXCLUDE_DIRS" >> config.cfg

log "INFO " "StoreBackup Options"
bin/storeBackup.pl --print -f config.cfg
log "INFO " "Started Backup"
while [ true ]; do
    bin/storeBackup.pl -f config.cfg
    current_epoch=$(date +%s.%N)
    target_epoch=$(date -d 'tomorrow 00:00' +%s)
    sleep_seconds=$(echo "$target_epoch - $current_epoch" | bc)
    log "INFO " "Goodnight i will sleep until tomorrow ($sleep_seconds secs)"
    sleep $sleep_seconds
    if $? -eq 0; then
        log "INFO " "Good Morning, i will start with the backup now!"
    else
        log "ERROR" "Exit now, sleep was aborted"
        exit 0
    fi
done
