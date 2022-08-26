#!/bin/sh

## RUN USING 'sh -x countly-backup.sh 2>&1 | tee debug.txt' to get DEBUG OUTPUT AND LOG

##############################################################################################################################
##                                          PLEASE SET ALL THE OPTIONS BELOW                                                ##
##                      PLEASE SET UP SSH KEYS WITH CONFIG BEFORE ATTEMPTING REMOTE BACKUP                                  ##
##  http://kiteplans.info/2015/05/13/how-to-linux-ssh-key-password-free-automatic-config-authentication-backup-sftp-scp/

## SET REMOTE BACKUP TRUE OR FALSE - DEFAULTS TO LOCALBACKUP
REMOTEBACKUP=false

## SET REMOTESERVER INFO IF USING REMOTE BACKUP - REMEMBER TO FIRST ENABLE SSH KEYS AS IN THE GUIDE ABOVE
REMOTESERVER=backup-server-nickname

## SET REMOVEDEST
REMOTEDEST=/home/backup-user/countly-backup

## SET LOCAL DEST - SCRIPT DEFAULTS TO MOVING TAR TO LOCAL DESTINATION
LOCALDEST=/home/yourdest/countly-backup/

## ROTATE BACKUP TRUE OR FALSE
ROTATEBACKUP=false

## SET KEEPDAYS IF USING ROTATEBACKUP - X AMOUNT OF DAYS BEFORE ROTATING
KEEPDAYS=7

## SET COUNLY BACKUP SCRIPT ROOT - BACKUP LOG CREATED HERE
BACKUPROOT=/var/countly-backup

## SET BACKUP DIR/TAR NAME
BACKUPDIRVAR=hostname-countly-backup

##############################################################################################################################
##                              DO NOT EDIT FROM HERE - EXCEPT IF YOU KNOW WHAT YOU ARE DOING                               ##

## SET DATE 
DATE=`date +%Y-%m-%d`

## START IF ROTATEBACKUP
if $ROTATEBACKUP
then
	BACKUPDIR=$BACKUPDIRVAR-$DATE
else
	BACKUPDIR=$BACKUPDIRVAR
fi
## END IF ROTATEBACKUP

## CREATE BACKUPROOT
mkdir -p $BACKUPROOT

## CREATE BACKUPDIR
mkdir -p $BACKUPROOT/$BACKUPDIR

## RUN BACKUP
countly backup $BACKUPROOT/$BACKUPDIR

## TAR THE WHOLE BACKUP DIR AND REMOVE DIR IF SUCCESSFUL
tar cfz $BACKUPROOT/$BACKUPDIR.tar.gz $BACKUPROOT/$BACKUPDIR && rm -R $BACKUPROOT/$BACKUPDIR

## START IF REMOTEBACKUP ELSE LOCALBACKUP
if $REMOTEBACKUP;
then
## SEND TAR TO REMOTE SERVER
sftp $REMOTESERVER <<_EOF_
    put $BACKUPROOT/$BACKUPDIR.tar.gz $REMOTEDEST/$BACKUPDIR.tar.gz
    bye
_EOF_

    ## START IF ROTATEBACKUP REMOVE OLD
    if $ROTATEBACKUP
    then
ssh -T $REMOTESERVER <<_EOF_
    find $REMOTEDEST/$BACKUPDIRVAR-* -mtime +$KEEPDAYS -exec rm -v {} \; | tee -a $REMOTEDEST/countly-backup.log
    exit
_EOF_
    fi
    ## END IF ROTATEBACKUP REMOVE OLD

    ## REMOVE LOCAL TAR
    rm -v $BACKUPROOT/$BACKUPDIR.tar.gz | tee -a $BACKUPROOT/countly-backup.log
else

    ## MAKE LOCALDEST
    mkdir $LOCALDEST

    ## MOVE TAR TO LOCALDEST
    mv -v $BACKUPROOT/$BACKUPDIR.tar.gz $LOCALDEST | tee -a $BACKUPROOT/countly-backup.log

    ## START IF ROTATEBACKUP REMOVE OLD
    if $ROTATEBACKUP
    then
        find $LOCALDEST/$BACKUPDIRVAR-* -mtime +$KEEPDAYS -exec rm -v {} \; | tee -a $BACKUPROOT/countly-backup.log
    fi
    ## END IF ROTATEBACKUP REMOVE OLD
fi
## END IF REMOTEBACKUP ELSE LOCALBACKUP
