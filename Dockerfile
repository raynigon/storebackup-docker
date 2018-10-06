FROM alpine

ENV RUN_ENDLESS true
ENV STOREBACKUP_VERSION=3.5
ENV SERIES_NAME=default
ENV BACKUP_DURATION=30d
ENV BACKUP_DURATION_FIRST_OF_WEEK=30d
ENV BACKUP_DURATION_FIRST_OF_MONTH=30d
ENV BACKUP_DURATION_DUPLICATES=7d
ENV BACKUP_MIN_NUMBER=1
ENV BACKUP_MAX_NUMBER=999999

# Change Workingdir
WORKDIR /app/
# Copy Backup Script
COPY backup.sh /app/
# Install Tools
RUN apk update && apk upgrade && \
    apk add bash \
    bc \
    wget \
    gzip \
    perl \
    coreutils && \
    rm -rf /var/cache/apk/* && \
# Create Mounting Points
    mkdir -p /data/source/ && \
    mkdir -p /data/destination/ && \
    chmod 775 backup.sh && \
# Install Storebackup
    wget http://download.savannah.gnu.org/releases/storebackup/storeBackup-${STOREBACKUP_VERSION}.tar.bz2 && \
    tar -jxvf storeBackup-${STOREBACKUP_VERSION}.tar.bz2 && \
    mv storeBackup/* . && \
# Remove uncecessary stuff
    rm -r storeBackup/ _ATTENTION_ && \
    rm -r storeBackup-${STOREBACKUP_VERSION}.tar.bz2 && \
    rm -r cron-storebackup man doc correct.sh
    
VOLUME [ "/data/source/", "/data/destination/" ]

CMD ["/app/backup.sh"]
