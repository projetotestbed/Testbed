#------------------------------------------------
#
# Load a binary file into telosb mote (type 2)
# ** It uses remote transfer file script **
#
#------------------------------------------------
#  $1 - netId
#  $2 - mote id
#  $3 - control channel address
#------------------------------------------------
./transfer.sh $3 tb_bin.ihex.out-$1-$2 
#------------------------------------------------
 
