#------------------------------------------------
#
# Load a binary noop file into telosb mote (type 2)
# ** It uses remote transfer file script **
#
#------------------------------------------------
#  $1 - mote id
#  $2 - mote id
#  $3 - control channel address
#------------------------------------------------
./transfer.sh $3 noop_telosb.ihex 
#------------------------------------------------
 
