#------------------------------------------------
#
# Start "TBrelay.py" application for all motes from TBNetx.cfg
#
#------------------------------------------------
#  $1 - ClientIP
#  $2 - NetID
#  $3 - NetVersion
#  $4 - TestID
#  $5 - TBControlPID
#  $6 - TBNet.cfg path+file
#------------------------------------------------
trap 'kill $(jobs -p)' EXIT
#while true; do
    ~/Testbed/TBControl/files/TBrelay.py "$1" $2 $3 $4 $5 $6
#done
#------------------------------------------------
