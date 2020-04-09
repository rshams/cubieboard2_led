#!/bin/sh
DEVMEM="/sbin/devmem"

# LED1 (PH21, Blue)
LED1_CFG_ADDR=0x01C20904
LED1_CFG_VAL=$(( 1<<20 ))
LED1_CFG_MASK=$(( ~(7<<20) & 0xFFFFFFFF ))
LED1_DTA_ADDR=0x01C2090C
LED1_DTA_MASK=$(( ~(1<<21) & 0xFFFFFFFF ))
LED1_DTA_ON=$(( 1<<21 ))
LED1_DTA_OFF=$(( 0<<21 ))

# LED2 (PH20, Green)
LED2_CFG_ADDR=0x01C20904
LED2_CFG_VAL=$(( 1<<16 ))
LED2_CFG_MASK=$(( ~(7<<16) & 0xFFFFFFFF ))
LED2_DTA_ADDR=0x01C2090C
LED2_DTA_MASK=$(( ~(1<<20) & 0xFFFFFFFF ))
LED2_DTA_ON=$(( 1<<20 ))
LED2_DTA_OFF=$(( 0<<20 ))

print_help() {
	echo "Usage: $0 <LED1 | LED2> <ON | OFF>"
}

set_reg() {
	# $1: Address
	# $2: Length (bit)
	# $3: Value
	# $4: Mask
	VAL=$($DEVMEM $1 $2)
	let "VAL&=$4"
	let "VAL|=$3"
	$DEVMEM $1 $2 $VAL
}

case $1 in
LED1)
	# Set LED port direction
	set_reg $LED1_CFG_ADDR 32 $LED1_CFG_VAL $LED1_CFG_MASK
	case $2 in
	ON)
		set_reg $LED1_DTA_ADDR 32 $LED1_DTA_ON $LED1_DTA_MASK
		;;
	
	OFF)
		set_reg $LED1_DTA_ADDR 32 $LED1_DTA_OFF $LED1_DTA_MASK
		;;
	*)
		print_help
		;;
	esac	
	;;
	
LED2)
	# Set LED port direction
	set_reg $LED2_CFG_ADDR 32 $LED2_CFG_VAL $LED2_CFG_MASK
	case $2 in
	ON)
		set_reg $LED2_DTA_ADDR 32 $LED2_DTA_ON $LED2_DTA_MASK
		;;
	
	OFF)
		set_reg $LED2_DTA_ADDR 32 $LED2_DTA_OFF $LED2_DTA_MASK
		;;
	*)
		print_help
		;;
	esac	
	;;

*)
	print_help
	;;
esac

