#!/bin/bash

#Create Database:
#   Implement a function to create a new database.
#   Accept the database name as a command-line argument.
#   Create a file for the database with the given name (e.g., example_db.txt).
#Create Table:
#   Implement a function to create a table within the database.
#   Accept the table name and fields as command-line arguments.
#   Ensure the table adheres to the specified format.
#Select Data:
#   Implement a function to select and display data from the table.
#   Ensure proper formatting and adhere to the specified row length.
#Delete Data:
#   Implement a function to delete data from the table.
#   Accept criteria for deletion as command-line arguments.
#Insert Data:
#   Implement a function to insert data into the table.
#   Accept data values as command-line arguments.
#   Ensure proper formatting and adherence to the specified row length.

#Database Structure:

#Ensure the database file adheres to the specified structure: Maximum line length of 39 characters.
#One field length of 7 characters (including spaces, excluding stars). 8 = ** + space + 6 (of text) + space + **
#Two stars at the start and end of each row.
#One space before text starts.

#Example of the table
#Table can contain maximum 4 fields, because (as requires 39 line ix max line length, 
#1 field is maximum length of 12 ( 4x"*" + 8 text symbols )

# ***************************************
# ** Name  ** Age   ** Dept  ** Code  **
# ** Alice ** 30    ** HR    ** A102  **
# ** Bob   ** 45    ** IT    ** B207  **
# ** Carol ** 28    ** MKT   ** C309  **
# ** Dave  ** 34    ** ENG   ** D403  **
# ***************************************

#Error Handling:

#Implement error handling for cases such as invalid commands, missing arguments, etc.
#Provide meaningful error messages for better user understanding.
#Testing:

#Test the database service with various scenarios to ensure its functionality and reliability.

#Documentation:

#Document the usage of each function and the overall structure of the database service.
#Code Organization:

#Organize the code in a modular and readable manner.


#Example of usage
# Create a new database
    #./database.sh create_db example_db

# Create a table in the database
    #./database.sh create_table example_db persons id name height age

# Insert data into the table
    #./database.sh insert_data example_db persons 0 Igor 180 36
    #./database.sh insert_data example_db persons 1 Pyotr 178 25

# Select and display data
    #./database.sh select_data example_db persons

# Delete data from the table
    #./database.sh delete_data example_db persons "id=1"


MAX_SYMBOLS=5 # max symbols in the field

function print_usage() {
    echo ""
    echo "USAGE: task_advanced.sh is a utility to create and manage databases with tables."
    echo "Available functions you can utilize:"
    echo "  - create_db       - Creates a database. Arguments order: <db_name>"
    echo "  - create_table    - Creates a table. Arguments order: <db_name>, <table_name>, <field 1>, [<field 2>], [<field 3>], [<field 4>]"
    echo "  - select_data     - Selects data. Arguments order: <db_name>, <table_name>"
    echo "  - delete_data     - Deletes data. Arguments order: <db_name>, <table_name>, <field_1=\"value\">"
    echo "  - insert_data     - Inserts data. Arguments order: <db_name>, <table_name>, <data for field 1>, [<data for field 2>], [<data for field 3>], [<data for field 4>]"
    echo ""
}


# Database creation. Accepts args: $1=<db_name>
function create_db() {              
    db_name=$1

    if [[ "${#db_name}" -gt 28 ]]; then
        echo "Please provide a shorter name for the database. It must be a maximum of 28 characters."
        exit 1
    fi

    if [[ -f $db_name ]]; then
        : > $db_name
        echo "Database with that name '$db_name' is already exists. Database has been cleared."
        echo "DATABASE \"$db_name\"" >> $db_name
    else
        touch $db_name
        echo "Database \"$db_name\" has been created."
        echo "DATABASE \"$db_name\"" >> $db_name
    fi
}



# Table creation. Accepts args: $1=<db_name>, $2=<table_name>, ${3}=<field 1>, [${4}=<field 2>], [${5}=<field 3>], [${6}=<field 4>]
# ***************************************
# ** Name  ** Age   ** Dept  ** Code  **
# ** Alice ** 30    ** HR    ** A102  **
# ** Bob   ** 45    ** IT    ** B207  **
# ** Carol ** 28    ** MKT   ** C309  **
# ** Dave  ** 34    ** ENG   ** D403  **
# ***************************************
function create_table() {
    db_name=$1
    table_name=$2
    shift 2
    fields_name=($@)

    number_of_fields="${#fields_name[@]}"
    stars=""


    if [[ -z $db_name ]] || [[ -z $table_name ]] || [[ -z $fields_name ]]; then
        echo "Please. Provide appropriate arguments."
        print_usage
        exit 1
    fi


    if [[ ${#fields_name[@]} -lt 1 || ${#fields_name[@]} -gt 4 ]]; then     # Number of applied fields check
        echo "Incorrect number of fields."
        echo "Error: The number of fields must be between 1 and 4."
        exit 1
    else
        for i in "${!fields_name[@]}"; do      # Number of characters in one field check
            if [[ "${#fields_name[i]}" -gt "${MAX_SYMBOLS}" ]]; then
                echo "Field name '${fields_name[i]}' is inappropriate. Field length must be between 1 and $MAX_SYMBOLS characters."
                exit 1
            fi
        done
    fi

    echo ""
    echo "Fields names "${fields_name[@]}" are correct."
    echo ""

    echo "" >> $db_name
    echo "" >> $db_name
    echo "== TABLE \"$table_name\" ==" >> $db_name
    
    # Stars in the beginning printing
    case $number_of_fields in
        1)
            stars=$( printf '*%.0s' {1..11} )
            echo "${stars}" >> $db_name
            ;;
        2)
            stars=$( printf '*%.0s' {1..20} )
            echo "${stars}" >> $db_name
            ;;
        3)
            stars=$( printf '*%.0s' {1..29} )
            echo "${stars}" >> $db_name
            ;;
        4)
            stars=$( printf '*%.0s' {1..39} )
            echo "${stars}" >> $db_name
            ;;
    esac


    for i in "${!fields_name[@]}"; do      # Number of characters in one field check
        length=${#fields_name[i]}
        padding=$(( $MAX_SYMBOLS - $length ))
        exit_field=$( printf '%*s' "${padding}" '')
        exit_field="${fields_name[i]}${exit_field}"
        echo -n "** ${exit_field} **" >> $db_name
    done
    echo "Table \"${table_name}\" with fields ${fields_name[@]} has been created."
    sed -i '' "s/\\*\\*\\*\\* /\\*\\* /g" "${db_name}"
    echo "" >> $db_name
    echo "${stars}" >> $db_name
}


# Data selection. Accepts args: $1=<db_name>, $2=<table_name>
function select_data() {
    db_name=$1
    table_name=$2
    table_scope=2

    if [[ -z $db_name ]] || [[ -z $table_name ]]; then
        echo "Please. Provide appropriate arguments."
        print_usage
        exit 1
    fi

    echo ""

    line_number=$( grep -n "== TABLE \"$table_name\" ==" "$db_name" | awk -F ':' '{print $1}' )
    if [[ $line_number -eq '' ]]; then
        echo "Table ${table_name} does not exists or provided name is incorrect."
        exit 1
    fi
    while [[ $table_scope -gt 0 ]]
    do
        line=$( sed -n "${line_number}p" "$db_name" )
        printf '%s\n' "$line"
        if [[ $line =~ '*******' ]]; then
            table_scope=$(( $table_scope - 1 ))
        fi
        line_number=$(( $line_number + 1 ))
    done
}


# Data deletion. Accepts args: $1=<db_name>, $2=<table_name>, $3=<field_1="value">
function delete_data() {
    db_name=$1
    table_name=$2
    line_to_delete=$3
    line_to_delete=${line_to_delete:1:${#line_to_delete}-2}
    table_scope=2
    index_of_field=""
    deleted=false

    if [[ -z $db_name ]] || [[ -z $table_name ]] || [[ -z $line_to_delete ]]; then
        echo "Please. Provide appropriate arguments."
        print_usage
        exit 1
    fi


    column_row_to_delete=$( echo "$line_to_delete" | awk -F '=' '{print $1}')
    
    column_value_to_delete=$( echo "$line_to_delete" | awk -F '=' '{print $2}')

    line_number=$( grep -n "== TABLE \"$table_name\" ==" "$db_name" | awk -F ':' '{print $1}' )

    fields_names=($( sed -n "$(( $line_number + 2 ))p" "$db_name" | awk -F '\\*\\*' '{for (i=2; i<NF; i++) print $i}'))

    
    for i in ${!fields_names[@]}; do
        if [[ ${fields_names[i]} == $column_row_to_delete ]]; then
            index_of_field=$(( $i + 2 ))
        fi
    done

    if [[ ${index_of_field} == "" ]]; then
        echo "Please provide a correct field name."
        exit 1
    fi

    while [[ $table_scope -gt 0 ]]
    do
        line=$( sed -n "${line_number}p" "$db_name" )
        if [[ $line =~ '** ' ]];then
            analysed_value=$( printf '%s\n' "$line" | awk -F '\\*\\*' -v id="$index_of_field" '{print $id}' )
            analysed_value="$( echo $analysed_value )"
            if [[ "${analysed_value}" == "${column_value_to_delete}" ]]; then
                sed -i '' "${line_number}d" "${db_name}"
                line_number=$(( $line_number - 1 ))
                deleted=true
            fi
        fi
        if [[ $line =~ '*******' ]]; then
            table_scope=$(( $table_scope - 1 ))
        fi
        line_number=$(( $line_number + 1 ))
    done
    if [[ "${deleted}" == "true" ]]; then
        echo "Data have been deleted."
    else
        echo "Data haven't been deleted."
    fi

}



# Data insertion. Accepts args: $1=<db_name>, $2=<table_name>, ${3}=<data for field 1>, [${4}=<data for field 2>], 
# [${5}=<data for field 3>], [${6}=<data for field 4>]
function insert_data() {
    db_name=$1
    table_name=$2
    shift 2
    insert_data=($@)
    table_scope=2       # start and the beginning of the table


    if [[ -z $db_name ]] || [[ -z $table_name ]] || [[ -z $insert_data ]]; then
        echo "Please. Provide appropriate arguments."
        print_usage
        exit 1
    fi

    line_number=$( grep -n "== TABLE \"$table_name\" ==" "$db_name" | awk -F ':' '{print $1}' )
    if [[ $line_number -eq '' ]]; then
        echo "Table ${table_name} does not exists or provided name is incorrect."
        exit 1
    fi

    fields_names=($( sed -n "$(( $line_number + 2 ))p" "$db_name" | awk -F '\\*\\*' '{for (i=2; i<NF; i++) print $i}'))
    if [[ ${#insert_data[@]} -ne ${#fields_names[@]} ]]; then     # Check if number of provided arguments equals to the number of fields in the table
        echo "The number of provided data values is incorrect. Please provide data for all ${#fields_names} fields."
        exit 1
    fi

    while [[ $table_scope -gt 0 ]]      # ind a line to paste data before
    do
        line=$( sed -n "${line_number}p" "$db_name" )
        if [[ $line =~ '*******' ]]; then
            table_scope=$(( $table_scope - 1 ))
        fi
        line_number=$(( $line_number + 1 ))
    done


    for i in "${!insert_data[@]}"; do      # Number of characters in one data field check
        if [[ "${#insert_data[i]}" -gt "${MAX_SYMBOLS}" ]]; then
            echo "Data '${insert_data[i]}' is inappropriate. Field length must be between 1 and $MAX_SYMBOLS characters."
            exit 1
        fi
    done

    tmp_var=""
    for i in "${!insert_data[@]}"; do      # Number of characters in one field check
        length=${#insert_data[i]}
        padding=$(( $MAX_SYMBOLS - $length ))
        exit_field=$( printf '%*s' "${padding}" '')
        exit_field="${insert_data[i]}${exit_field}"
        tmp_var="${tmp_var}** ${exit_field} **" >> $db_name
    done

    data_to_insert=$( echo "${tmp_var}" | sed "s/\\*\\*\\*\\* /\\*\\* /g" )
    line_before_insertion="$(( $line_number - 1 ))i"
    sed -i '' "${line_before_insertion}\\ 
$data_to_insert
" "${db_name}"    # Paste data before the end of the table
}


#Checking if function name is correct
FUNC_NAME=$1
shift

if declare -f $FUNC_NAME > /dev/null && [[ ${#@} -ne 0 ]]; then
    echo "Function $FUNC_NAME exists"
    "${FUNC_NAME}" "${@}"
else
    if [[ "$FUNC_NAME" == '' ]]; then
        echo "Please provide a function name as an argument."
    else
        echo "Function '$FUNC_NAME' does not exist."
    fi
    print_usage
fi