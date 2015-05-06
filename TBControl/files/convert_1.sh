#------------------------------------------------------------
#
# Testbed Control - Convert .exe file to srec format
# Node Type 1 - micaZ
#
#------------------------------------------------------------
# $1 - NetID
# $2 - NodeID
# $3 - LogicalID
# $4 - input file name - userfile table
#------------------------------------------------------------
avr-objcopy --output-target=srec $4.exe $4.srec
tos-set-symbols $4.srec tb_bin.srec.out-$1-$2 TOS_NODE_ID=$3 ActiveMessageAddressC__addr=$3
#------------------------------------------------------------

