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

echo ""

if [[ -f $INPUTFILE ]]; then
    echo "Input file $INPUTFILE exists."
    echo ""
else
    echo "Input file $INPUTFILE doesn't exist."
    exit 1
fi

if [[ -f $OUTPUTFILE ]]; then
    echo "Output file $OUTPUTFILE exists."
    : > $OUTPUTFILE
    echo "File $OUTPUTFILE has been cleared."
    echo ""
else
    echo "Output file $OUTPUTFILE doesn't exists"
    touch $OUTPUTFILE
    echo "File $OUTPUTFILE has been created"
    echo ""
fi

cat -e $INPUTFILE | while IFS= read -r -n1 char; do
    NEWCHAR=""
    for i in "${!ALPHABET[@]}"; do
        if [[ "${ALPHABET[i]}" == "${char^^}" ]]; then
            NEWINDEX=$(( i + SHIFT ))
            if [[ $NEWINDEX -gt "${#ALPHABET[@]}" ]]; then
                NEWINDEX=$(( 0 - (${#ALPHABET[@]} - NEWINDEX) ))
                NEWCHAR="${ALPHABET[NEWINDEX]}"
                if [[ "$char" =~ [a-z] ]]; then
                    NEWCHAR="${NEWCHAR,,}"
                fi
            else
                NEWCHAR="${ALPHABET[NEWINDEX]}"
                if [[ "$char" =~ [a-z] ]]; then
                    NEWCHAR="${NEWCHAR,,}"
                fi
            fi
        fi
    done
    
    if [[ "${char}" == '$' ]]; then
        echo "" >> $OUTPUTFILE
    elif [[ "${NEWCHAR}" == "" ]]; then
        NEWCHAR="${char}"
    fi
    
    echo -n "${NEWCHAR}" >> $OUTPUTFILE
done

echo ""
echo "Text before cipher:"
echo ""
cat $INPUTFILE
echo ""
echo ""
echo "Text before cipher:"
echo ""
cat $OUTPUTFILE
