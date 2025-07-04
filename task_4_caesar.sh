#!/bin/bash

# Write caesar cipher script accepting three parameters -s <shift> -i <input file> -o <output file>

SHIFT=""
INPUTFILE=""
OUTPUTFILE=""
ALPHABET=( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z )

while getopts ":s:i:o:" opt; do
    case $opt in
        s)
            SHIFT="$OPTARG"
            ;;
        i)
            INPUTFILE="$OPTARG"
            ;;
        o)
            OUTPUTFILE="$OPTARG"
            ;;
    esac
done

if [[ -f $INPUTFILE ]]; then
    echo "Text before cipher:"
    cat $INPUTFILE
else
    echo "File doesn't exists"
fi

while IFS= read -r -n1 char; do
    echo "CHar: $char"
done < $INPUTFILE

