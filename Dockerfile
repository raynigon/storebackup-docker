FROM alpine

ENV STOREBACKUP_VERSION=3.5
ENV SERIES_NAME=default
ENV BACKUP_DURATION=30d
ENV BACKUP_DURATION_FIRST_OF_WEEK=30d
ENV BACKUP_DURATION_FIRST_OF_MONTH=30d
ENV BACKUP_DURATION_DUPLICATES=7d
ENV BACKUP_MIN_NUMBER=1
ENV BACKUP_MAX_NUMBER=999999

# Install Tools
RUN apk update && apk upgrade
RUN apk add bash bc wget gzip perl coreutils

# Change Workingdir
WORKDIR /app/

# Install Storebackup
RUN wget http://download.savannah.gnu.org/releases/storebackup/storeBackup-${STOREBACKUP_VERSION}.tar.bz2 && \
    tar -jxvf storeBackup-${STOREBACKUP_VERSION}.tar.bz2

RUN mkdir -p /app/ && \
    mkdir -p /data/source/ && \
    mkdir -p /data/destination/

COPY backup.sh /app/
RUN chmod 775 backup.sh

VOLUME [ "/data/source/", "/data/destination/" ]

CMD ["/app/backup.sh"]