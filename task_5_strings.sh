#!/bin/bash

#Write script with following functionality:
#If -v tag is passed, replaces lowercase characters with uppercase and vise versa
#If -s is passed, script substitutes <A_WORD> with <B_WORD> in text (case sensitive)
#If -r is passed, script reverses text lines
#If -l is passed, script converts all the text to lower case
#If -u is passed, script converts all the text to upper case
#Script should work with -i <input file> -o <output file> tags

ALLARGS=("$@")
OUTFILE=false
INFILE=false
CASE_STATUS=false

OUTPUTFILENAME=""
INPUTFILENAME=""


echo ""

for i in "${!ALLARGS[@]}";do
    if [[ ${ALLARGS[i]} == "-i" ]] && [[ -f ${ALLARGS[i+1]} ]]; then
        INPUTFILENAME="${ALLARGS[i+1]}"
        INFILE=true
        echo "Check input file. The file ${INPUTFILENAME} exists."
    fi
    if [[ ${ALLARGS[i]} == "-o" ]]; then 
        OUTPUTFILENAME="${ALLARGS[i+1]}"
        if [[ ! -f "${OUTPUTFILENAME}" ]]; then
            if ! touch "$OUTPUTFILENAME" 2> /dev/null; then
                echo "Wrong output filename..."
                exit 1
            fi
        else
            : > "$OUTPUTFILENAME"
            echo "Check output file. The file ${OUTPUTFILENAME} already exists. The file has been cleared."
        fi
        OUTFILE=true
    fi
done


if [[ $OUTFILE != true || $INFILE != true ]]; then
    echo "USAGE: Provide -o [output_file] -i [input_file] [additional_options]"
    exit 1
fi

echo ""
echo "Chosen options:"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -v)
            CASE_STATUS=true
            shift
            ;;
        -s)
            shift
            A_WORD=$1
            B_WORD=$2
            if [[ $( wc -c < "$OUTPUTFILENAME" ) -ne 0 ]]; then
                sed -i "s/${A_WORD}/${B_WORD}/g" "$OUTPUTFILENAME"
            else
                sed "s/${A_WORD}/${B_WORD}/g" "$INPUTFILENAME" > "$OUTPUTFILENAME"
            fi
            shift 2
            echo "-s -- Word ${A_WORD} has been replaced with ${B_WORD}."
            ;;
        -r)
            shift
            if [[ $( wc -c < "$OUTPUTFILENAME" ) -ne 0 ]]; then
                tail -r "$OUTPUTFILENAME" > tmp
                cat tmp > "$OUTPUTFILENAME"
                rm tmp
            else
                tail -r "$INPUTFILENAME" > "$OUTPUTFILENAME"
            fi
            echo "-r -- Lines order has been reversed."
            ;;
        -l)
            shift
            if [[ $( wc -c < "$OUTPUTFILENAME" ) -ne 0 ]]; then
                tr 'A-Z' 'a-z' < "$OUTPUTFILENAME" > tmp
                cat tmp > "$OUTPUTFILENAME"
                rm tmp
            else
                tr 'A-Z' 'a-z' < "$INPUTFILENAME" > "$OUTPUTFILENAME"
            fi
            echo "-l -- Lowercase has been applied"
            ;;
        -u)
            shift
            if [[ $( wc -c < "$OUTPUTFILENAME" ) -ne 0 ]]; then
                tr 'a-z' 'A-Z' < "$OUTPUTFILENAME" > tmp
                cat tmp > "$OUTPUTFILENAME"
                rm tmp
            else
                tr 'a-z' 'A-Z' < "$INPUTFILENAME" > "$OUTPUTFILENAME"
            fi
            echo "-u -- Uppercase has been applied"
            ;;
        -i)
            shift 2
            ;;
        -o)
            shift 2
            ;;
    esac
done


if [[ $CASE_STATUS == true ]]; then
    touch tmp
    cat -e "$OUTPUTFILENAME" | while IFS= read -r -n1 CHAR; do
        if [[ $CHAR =~ [a-z] ]]; then
            echo -n "${CHAR^^}" >> tmp
        elif [[ $CHAR =~ [A-Z] ]]; then
            echo -n "${CHAR,,}" >> tmp
        elif [[ $CHAR == "$" ]]; then
            echo >> tmp
        else
            echo -n "${CHAR}" >> tmp
        fi
    done
    cat tmp > "$OUTPUTFILENAME"
    rm tmp
    echo "-v -- Characters' cases have been reversed."
fi

echo ""
echo ""

echo "Input file text '$INPUTFILENAME':"
echo ""
cat "$INPUTFILENAME"

echo ""
echo ""

echo "Output file text '$OUTPUTFILENAME':"
echo ""
cat "$OUTPUTFILENAME"