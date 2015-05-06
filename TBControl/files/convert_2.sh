#------------------------------------------------------------
#
# Testbed Control - Convert .exe file to ihex format
# Node Type 2 - TelosB
#
#------------------------------------------------------------
# $1 - NetId
# $2 - NodeID
# $3 - LogicalID
# $4 - input file name - userfile table
#------------------------------------------------------------
msp430-objcopy --output-target=ihex $4.exe $4.ihex
tos-set-symbols --objcopy msp430-objcopy --objdump msp430-objdump --target ihex $4.ihex tb_bin.ihex.out-$1-$2 TOS_NODE_ID=$3 ActiveMessageAddressC__addr=$3 
#------------------------------------------------------------

