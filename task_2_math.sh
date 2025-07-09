#!/bin/bash

OPERATION=""
NUMBERS=()
INFO_STATUS=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o)
            OPERATION="$2"
            shift 2
            ;;
        -n)
            shift
            while [[ $# -gt 0 && "$1" != -* ]]; do
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


case $OPERATION in
    "-")
        RESULT="${NUMBERS[0]}"
        for (( i=1; i<"${#NUMBERS[@]}"; i++ )); do
            RESULT=$(( $RESULT - ${NUMBERS[i]}))
        done
        ;;
    "+")
        RESULT="${NUMBERS[0]}"
        for (( i=1; i<"${#NUMBERS[@]}"; i++ )); do
            RESULT=$(( $RESULT + ${NUMBERS[i]}))
        done
        ;;
    "*")
        RESULT="${NUMBERS[0]}"
        for (( i=1; i<"${#NUMBERS[@]}"; i++ )); do
            RESULT=$(( $RESULT * ${NUMBERS[i]}))
        done
        ;;
    "%")
        RESULT="${NUMBERS[0]}"
        for (( i=1; i<"${#NUMBERS[@]}"; i++ )); do
            if [[ "${NUMBERS[i]}" -eq 0 ]];then
                echo "Division by 0. Exit ..."
                exit 1
            fi
            RESULT=$(( $RESULT % ${NUMBERS[i]}))
        done
        ;;
    *)
        echo "Unsupported operation: $OPERATION"
        exit 1
        ;;
esac

echo ""
echo "Result is $RESULT"
echo ""

if [[ "$INFO_STATUS" == true ]]; then
        echo "User: $USER"
        echo "Script: $0"      
        echo "Operation: $OPERATION"
        echo "Numbers:" "${NUMBERS[@]}"
fi