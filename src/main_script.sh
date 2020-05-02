#!/bin/sh


INCLUDE_FILE=~/.config/servidor_rsync/servidor_incluir
EXCLUDE_FILE=~/.config/servidor_rsync/servidor_rsync_excluir
DUMP_FILE=~/.config/servidor_rsync/servidor_historial
BACKUP_FROM=carlos@192.168.100.51
BACKUP_DIR=~/.home_backup
SNAPSHOT_FNAME=~/.config/servidor_rsync/.servidor_rsync_snapshot
MAIN_DIR=~/.config/servidor_historial



## Get files to be excluded
COMMAND="ls ~ "
for dir in $(strings dirs.txt --encoding=S)
do
    COMMAND+="--ignore=\"${dir}\" "
done

eval $COMMAND > $EXCLUDE_FILE

# Para ser corrido desde la computadora destino
touch $DUMP_FILE
echo "Última sincronización:" >  $DUMP_FILE
echo $(date) | tee -a $DUMP_FILE


rsync -uaPz --delete --exclude-from $EXCLUDE_FILE  -e ssh $BACKUP_FROM:~/. /home/carlos/ | tee -a $DUMP_FILE || echo "Error al intentar sincronizar"

# Comprimir backup gradual

# ssh $BACKUP_SERVER 'tar -cvzg $DIR_FILE -f incremental_home_backup.tar.gz'

