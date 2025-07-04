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
#One row length of 8 characters (including spaces, excluding stars).
#Two stars at the start and end of each row.
#One space before text starts.
#Error Handling:

#Implement error handling for cases such as invalid commands, missing arguments, etc.
#Provide meaningful error messages for better user understanding.
#Testing:

#Test the database service with various scenarios to ensure its functionality and reliability.

#Documentation:

#Document the usage of each function and the overall structure of the database service.
#Code Organization:

#Organize the code in a modular and readable manner.

DB_NAME=$1

function create_database() {
    db_name=$1

    if [[ -f $db_name ]]; then
        : > $db_name
        echo "Database with that name '$db_name' is already exists. Database has been cleared."
    else
        touch $db_name
        echo "Database with '$db_name' has been created."
    fi
}

function create_table() {
    db_name=$1
    table_name=$2
    shift 2
    fields_name=($@)

    echo "" >> $db_name
    echo "Table \"$table_name\"" >> $db_name
    for i in "${!fields_name[@]}"; do
        echo -n "|${fields_name[i]}" >> $db_name
    done
    echo "|" >> $db_name
    echo "Table \"${table_name}\" with fields ${fields_name[@]} has been created."
}

#create_database "$DB_NAME"