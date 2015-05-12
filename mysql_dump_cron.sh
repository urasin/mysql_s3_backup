#/bin/bash -xv

# BASE_DIR
BASE_DIR=$(cd $(dirname $0); pwd)

# S3変数一覧
S3_BUCKET_NAME=""
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

# DB変数一覧
DB_NAME=""
DB_USER=""
DB_HOST=""
DB_PASS=""

# TimeZone
export TZ="JST-9"

# 年月日
YEAR=`date '+%Y'`
MONTH=`date '+%m'`
DAY=`date '+%d'`
HOUR=`date '+%H'`
MINUTE=`date '+%M'`
SECOND=`date '+%S'`

FOLDER_NAME=mysql_dump_cron/${YEAR}-${MONTH}
DUMP_FILE_NAME=goocus3_staging_${YEAR}-${MONTH}${DAY}-${HOUR}${MINUTE}${SECOND}.dump
mkdir -p ${FOLDER_NAME}

mysqldump -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} > ~/${FOLDER_NAME}/${DUMP_FILE_NAME}

s3cmd put -rr ${FOLDER_NAME}/${DUMP_FILE_NAME} s3://${S3_BUCKET_NAME}/staging/${FOLDER_NAME}/${DUMP_FILE_NAME}
