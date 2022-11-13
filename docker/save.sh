#!/bin/bash

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

DB_CONTAINER=$(read_var DB_CONTAINER .env)
BACKUP_DIRECTORY="dump_$DB_CONTAINER"

MYSQL_USER=$(read_var MYSQL_USER .env)
MYSQL_PASSWORD=$(read_var MYSQL_PASSWORD .env)
MYSQL_DATABASE=$(read_var MYSQL_DATABASE .env)

DB_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $DB_CONTAINER);

TODAY=$(date +"%Y-%m-%d")

mkdir -pv $BACKUP_DIRECTORY;

echo "Dumping $DB_CONTAINER... : "
mysqldump --single-transaction --no-tablespaces -h$DB_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE | gzip -c > $BACKUP_DIRECTORY/$DB_CONTAINER.${TODAY}.sql.gz;

echo "Suppression des dumps de plus de 7 jours... : "
find $BACKUP_DIRECTORY -mtime +7 -name '*.sql.gz' -exec rm -f {} \;
