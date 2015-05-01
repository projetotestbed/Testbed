#!/bin/sh
FTPLOG=./$3_ftplogfile
ftp -inv <<! > $FTPLOG
open $1 $2
user ftp pwd
put $3
quit
!

FTP_SUCCESS_MSG="226 Transfer complete"
if fgrep "$FTP_SUCCESS_MSG" $FTPLOG ;then
   echo 'Ok'
   exit 0
else
   echo 'Error'
   exit 1
fi

