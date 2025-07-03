#!/bin/bash

echo "Enter 'n' number:"
read n

F0=0
F1=1

function fib() {
    
    case $1 in
        0) echo "0";;
        1) echo "1";;
        *)
            echo $(( $(fib $(( $1 - 1 ))) + $(fib $(( $1 - 2 ))) ))
            ;;
    esac

}

for (( i=0; i<=$n; i++ )); do
    echo -n "$(fib $i) "
done
