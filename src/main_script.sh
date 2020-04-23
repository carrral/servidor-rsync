#!/bin/sh

DIR_FILE=~/.config/servidor_rsynd/.servidor_rsync
DUMP_FILE=~/.config/.servidor_historial
BACKUP_SERVER=carlos@192.168.100.14
BACKUP_DIR=~/.home_backup
SNAPSHOT_FNAME=~/.config/servidor_rsync/.servidor_rsync_snapshot
MAIN_DIR=~/.config/servidor_historial

touch $DUMP_FILE
echo "Última sincronización:" > $DUMP_FILE
echo $(date) >> $DUMP_FILE
echo "Directorios sincronizados:" >> $DUMP_FILE

for e in $(strings $DIR_FILE)
do
    echo "Sincronizando $e"
    echo $e > $DUMP_FILE
    rsync -az --delete -e ssh ~/$e $BACKUP_SERVER:~
done

# Comprimir backup gradual

ssh $BACKUP_SERVER 'tar -cvzg $DIR_FILE -f incremental_home_backup.tar.gz

