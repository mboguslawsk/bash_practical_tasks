#!/bin/bash

OPERATION=""
NUMBERS=()
INFO_STATUS=false
RESULT=0


while [[ $# -gt 0 ]]; do
    case "$1" in
        -o)
            OPERATION="$2"
            shift 2
            ;;
        -n)
            shift
            while [[ $# -gt 0 && "$1" != "-*" ]]; do
                NUMBERS+=("$1")
                shift
            done
            ;;
        -d)
            INFO_STATUS=true
            shift
            ;;
    esac
done


for (( i = 0; i < ${#NUMBERS[@]}; i++)); do
    number="${NUMBERS[i]}"
    case $OPERATION in
        "-")
            RESULT=$(($RESULT - $number))
            ;;
        "+")
            RESULT=$(($RESULT + $number))
            ;;
        "*")
            RESULT=$(($RESULT * $number))
            ;;
        "%")
            RESULT=$(($RESULT % $number))
            ;;
    esac
done

echo ""
echo "Result is $RESULT"
echo ""

if [[ "$INFO_STATUS" == true ]]; then
        echo "User: $USER"
        echo "Script: $0"      
        echo "Operation: $OPERATION"
        echo "Numbers: ${NUMBERS[@]}"
fi