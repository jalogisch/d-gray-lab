#!/bin/bash

BACKUPDIR=/Users/jd/bench/d-gray-lab/backup/mongo



# Test if Backup dir is present and create if not.
[[ -d ${BACKUPDIR} ]] || mkdir -p ${BACKUPDIR}



docker run --rm --link mongo:mongo --network=dgraylab_graylog.net \
	-v ${BACKUPDIR}:/backup mongo:3 \
	bash -c 'mongodump --out /backup --host mongo:27017'

