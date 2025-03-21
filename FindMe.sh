#!/bin/bash
PACKAGE_NAME='FindMe'
REPO_ROOT='https://github.com/Nadoooor/FindMe'
EXECUTABLE_FILE='FindMe.sh'

# Check for required tools
echo 'Are you using MacOs?? (yes or no)'
read sysinf
if [[ $sysinf == 'yes' ]]; then
    brew install toilet dialog boxes lolcat figlet
elif [ $sysinf == 'no' ]; then
clear
fi
if ! command -v toilet &> /dev/null; then
    sudo apt install figlet toilet || exit 1
fi
if ! command -v dialog &> /dev/null; then
    sudo apt install dialog || exit 1
fi
if ! command -v boxes &> /dev/null; then
    sudo apt install boxes || exit 1
fi
if ! command -v lolcat &> /dev/null; then
    sudo apt install lolcat || exit 1
fi

# Main loop
while true; do
    # Display title
    toilet -f ivrit 'FindMe' | boxes -d cat -a hc -p h8 | lolcat

    # Prompt user to start
    echo "Author: Nader Sayed"
    echo "Type 'start' to begin or 'exit' to quit."
    read start

    if [[ $start == 'exit' ]]; then
        echo "Exiting..."
        break
    fi

    if [[ $start == 'start' ]]; then
        # Display dialog menu
        loca=$(dialog --menu 'choose where to find' 0 0 3 '/' 'Find in the root dir' '/home' 'Find in the home dir for all users' "/home/$(whoami)" 'Find in the current user home dir' 3>&1 1>&2 2>&3)
        clear
        # Check if user selected an option
        if [ $? -eq 0 ]; then
            if [[ $loca == '/' || $loca == '/home' || $loca == "/home/$(whoami)" ]]; then
                # Display find method selection
                find_method=$(dialog --checklist 'Choose the methods that you want to use to find the file.' 0 0 7 "-name" 'Search by the name of the file' off "-type" 'select the file type (file ,dir)' off "-size" 'search for files (+n)greater or (-n)smaller then.' off "-iname" 'Searches for files with a specific name,regardless of case.' off "-readable" 'A file that you can read its content' off "-writable" 'A file that you can edit and change its content' off "-executable" 'A file that the sofware can run as a program.' off 3>&1 1>&2 2>&3)
                clear

                # Process the selected find methods
                if [ $? -eq 0 ]; then
                find_command="find \"$loca\""
                if [[ $find_method == *"-name"* ]]; then
                    file_name=$(dialog --inputbox "Enter the file name." 0 0 3>&1 1>&2 2>&3)
                    find_command+=" -name \"$file_name\" 2>/dev/null"
                fi
                if [[ $find_method == *"-type"* ]]; then
                    file_type=$(dialog --inputbox "Enter the file type (f for file or d for dir)." 0 0 3>&1 1>&2 2>&3)
                    find_command+=" -type \"$file_type\" 2>/dev/null"
                fi
                if [[ $find_method == *"-size"* ]]; then
                    file_size=$(dialog --inputbox "Enter the file size (+num to search more than the num or -num to search less than the num)." 0 0 3>&1 1>&2 2>&3)
                    find_command+=" -size \"$file_size\" 2>/dev/null"
                fi
                if [[ $find_method == *"-iname"* ]]; then
                    file_iname=$(dialog --inputbox "Enter the file name (Neglecting the capital and small letters)." 0 0 3>&1 1>&2 2>&3)
                    find_command+=" -iname \"$file_iname\" 2>/dev/null"
                fi
                 if [[ $find_method == *"-readable"* ]]; then
                    
                    find_command+=" -readable 2>/dev/null"
                fi
                if [[ $find_method == *"-writable"* ]]; then
                    
                    find_command+=" -writable 2>/dev/null"
                fi
                if [[ $find_method == *"-executable"* ]]; then
                    
                    find_command+=" -executable 2>/dev/null"
                fi
		clear
               if [ -z "$find_method" ]; then
      echo "Canceled..."
else
      results=$(eval "$find_command")  
      dialog --msgbox "$results" 10 80
      clear
fi
                
                else
                echo "Canceled..."
                fi
            else
            clear
                echo "No location selected. Returning to the beginning..."
                clear
            fi
        else
        clear
            echo "No option selected. Returning to the beginning..."
            clear
        fi
    else
    clear
        echo "Invalid input. Please type 'start' to begin or 'exit' to quit."
        clear
    fi
done
