#------------------------------------------------
#
# Load a binary noop file into micaz mote (type 1)
#
#------------------------------------------------
#  $1 - netId
#  $2 - mote id
#  $3 - control channel address
#------------------------------------------------

# load RATIO and OFFSET from included file
source loadParams_1.sh

SIZE=$(size noop_micaz.exe  | cut  -f1 | grep text -v)
TIMEOUT=$(echo "($SIZE/$RATIO)+$OFFSET" | bc -l)
#echo $SIZE $TIMEOUT

timeout $TIMEOUT uisp $3 --wr_fuse_h=0xd9 -dpart=ATmega128  --wr_fuse_e=ff   --erase --upload if=noop_micaz.srec --verify
#------------------------------------------------
 
