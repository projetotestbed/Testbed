@echo off
set "fname=%~n0"
set "mote_sn=%fname:*_=%"
c:/cygwin/bin/bash.exe -e -c "cd /home/tbdev/TBControl/files; /bin/python /home/tbdev/TBControl/files/bsl_data_server.py  -q -m %mote_sn%"