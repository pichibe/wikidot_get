#!/bin/bash
num1=$(echo "$1" | rg -o "offset/\d+" | rg -o "\d+")
num2=100

if [ "$num1" = "" ] ; then
	if [ "$2" != "" ] ; then
		num1=$(echo "$2" | rg -o "/offset/\d+" | rg -o "\d+")
	else
		num1=101
	fi
else
	num=$(echo "$2" | rg -o "/offset/\d+" | rg -o "\d+")
	num2=${num:-0}
fi

if [ "$num1" -lt "$num2" ] ; then
	echo "recuresion"
fi
