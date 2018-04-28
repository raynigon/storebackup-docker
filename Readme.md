# Storebackup Docker Container

## Execute
```
docker run -v '/home/:/data/source/' -v '/backup/:/data/destination/' raynigon/storebackup
```
Will create a Backup for the last 30 days of your '/home' folder to '/backup'.
Take a look at the enviroment variables and check how to adjust them for your needs.

## Configuration
### Enviroment Variables
- __SERIES_NAME__: The Name of this Series (default: default)
- __BACKUP_DURATION__: The Amount of time how long the Backups should be keept (default: 30d)
- __BACKUP_DURATION_FIRST_OF_WEEK__: How long the first backup of a week should be stored(default: 30d)
- __BACKUP_DURATION_FIRST_OF_MONTH__: How long the first backup of a month should be stored(default: 30d)
- __BACKUP_DURATION_DUPLICATES__: How long backups of the same day should be stored(default: 7d)
- __BACKUP_MIN_NUMBER__: Minimal number of Backups which should be keept (default: 1)
- __BACKUP_MAX_NUMBER__: Maximal number of Backups which should be keept (default: 999999)


__Example__:
```
docker run \
  -v '/home/:/data/source/' \
  -v '/backup/:/data/destination/' \
  -e BACKUP_DURATION=90d \
  -e BACKUP_DURATION_FIRST_OF_WEEK=365d \
  -e BACKUP_MIN_NUMBER=120 \
  raynigon/storebackup
```
Will backup your data for the last 90 days. There will be at least 120 backups and the first backup of a week will be saved for a year.

### Compose
You can use the container also with Docker Compose
__Example__:
```
storebackup:
  image: raynigon/storebackup
  container_name: StoreBackup
  restart: always
  volumes:
    - '/home/:/data/source/'
    - '/backup/:/data/destination/'
  environment: 
    - SERIES_NAME=Home
    - BACKUP_DURATION_FIRST_OF_WEEK=120d
    - BACKUP_DURATION_FIRST_OF_MONTH=120d
    - BACKUP_DURATION_DUPLICATES=3d
    - BACKUP_MIN_NUMBER=15
```
