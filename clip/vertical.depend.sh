#!/bin/bash

# Define options and corresponding commands horizontally
OPTIONS=("Edit " "Copy " "Execute " "Play ")
COMMANDS=("vim $1" "cp $1 ." "sudo -u batan bash $1" "mpv $1")
NUM_OPTIONS=${#OPTIONS[@]}

# Function to display options horizontally
DISPLAY_OPTIONS() {
tput setab 4;tput cuu1
	echo -ne "${White}\033[1G"  # Move cursor to beginning of the line
    for ((i=0; i<NUM_OPTIONS; i++)); do
        if [[ $i -eq $selected ]]; then
            echo -ne "\033[37m\e[7m${OPTIONS[i]}\e[27m "  # Highlight selected option
        else
            echo -n "${OPTIONS[i]} "
        fi
    done
	tput sgr0
}

# Function to execute selected command
EXECUTE_COMMAND() {

    echo "Executing command: ${COMMANDS[selected]}"
    # Execute the actual command associated with the selected option
    ${COMMANDS[selected]}
}

# Initialize
selected=0
DISPLAY_OPTIONS

# Main loop
while true; do
    read -s -n1 key  # Read user input
    case $key in
        A)  # Up arrow key
            ((selected--))
            ;;
        B)  # Down arrow key
            ((selected++))
            ;;
        "") # Enter key
            EXECUTE_COMMAND
            break
            ;;
    esac

    if [[ $selected -lt 0 ]]; then
        selected=$((NUM_OPTIONS - 1))
    elif [[ $selected -ge $NUM_OPTIONS ]]; then
        selected=0
    fi
    DISPLAY_OPTIONS
done

#EOL
#xfce4-terminal --hide-menubar --hide-scrollbar --hide-borders --zoom=-0.5 --geometry=190x1+100+100 -e "sudo -u batan bash $TMP_SCRIPT"

