#/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker

tput civic

#{{{>>>   Vars
#mapfile -t options < <(awk -F"#X#" 'NF > 1 {print $2}' /home/$USER/lc-V-complete.sh)
options=($(ls|cut -c1-45))
selected=0
total=${#options[@]}
MAX_DISPLAY=10
start_index=0
COUNTER="25"
#}}}
#{{{>>>   Decorations
HH="\033[36m│\033[0m"
HF="\033[37m┇\033[0m"
HS="\033[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

TR="\033[36m┌\033[0m"
TL="\033[36m┐\033[0m"
TH="\033[36m─\033[0m"
TT="\033[36m┬\033[0m"
TV="\033[36m│\033[0m"
TT="\033[36m├\033[0m"
TT="\033[36m┼\033[0m"
TT="\033[36m┤\033[0m"
BR="\033[36m└\033[0m"
BL="\033[36m┘\033[0m"
TT="\033[36m┴\033[0m"
TTOP="\033[36m└─────┴─────┴─────┴────────┴─────┴───────┴───────┴──────┘\033[0m"
BTOP="\033[36m├─────┴───┬─┴─────┴────────┴─────┴───────┴────┬──┴──────┤"
BBOTTOM="\033[36m┌─────┬─────┬─────┬────────┬─────┬───────┬───────┬──────┐\033[0m"
 BOTTOM="\033[36m└─────┴─────────────────────────────────────────────────┘\033[0m"
#}}}
add_tasks() {
runuser -u batan task add ${options[$selected]} project:Installation due:$(date +%Y-%m-%d)T23:30:00
}
refresh_menu() {
    tput cup 6 0
    show_menu  # Re-render the menu
}



#{{{>>>   lcedit

lcedit() {
# Define options and corresponding commands horizontally
OPTIONS=("Edit " "Copy " "Execute " "Play " "Upload " "Rename " "Trash ")
COMMANDS=("vim $1 " "cp $1 /home/$USER" "sudo -u batan bash $1" "mpv $1" "megaput $1" "qmv -f do -e vim $1 " "ltr $1 " )
NUM_OPTIONS=${#OPTIONS[@]}

# Function to display options horizontally
DISPLAY_OPTIONS() {
tput civis
#tput setab 4
tput cup 2 0
           echo -e $BTOP
           tput cup 0 0
            echo -e $BBOTTOM
            tput cup 1 0
            echo -e $TV
            tput cup 1 6
            echo -e $TV
            tput cup 1 7

#	echo -ne "${White}\033[1G"  # Move cursor to beginning of the line
    for ((i=0; i<NUM_OPTIONS; i++)); do
        if [[ $i -eq $selected ]]; then
            echo -ne "\033[37m\e[7m${OPTIONS[i]}\e[27m$TV"  # Highlight selected option
        else
            echo -ne "${OPTIONS[i]}$TV"
        fi
    done
#	tput sgr0
}

# Function to execute selected command
EXECUTE_COMMAND() {

    echo -e "   \033[36m>>>   \033[32mExecuting command: \033[37m${COMMANDS[selected]}"
    # Execute the actual command associated with the selected option
    ${COMMANDS[selected]}
    return 1

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
            return 1

            ;;
    esac

    if [[ $selected -lt 0 ]]; then
        selected=$((NUM_OPTIONS - 1))
    elif [[ $selected -ge $NUM_OPTIONS ]]; then
        selected=0
    fi
    DISPLAY_OPTIONS
done

}


#}}}

#{{{>>> MENU
function show_menu() {
 #   clear
    tput cup 0 0
echo -e "\033[36m┌─────┬─────┬─────┬────────┬─────┬───────┬───────┬──────┐"
echo -e "│     │\033[37mEdit \033[36m│\033[37mCopy \033[36m│\033[37mExecute \033[36m│\033[37mPlay \033[36m│\033[37mUpload \033[36m│\033[37mRename \033[36m│\033[37mTrash \033[36m│"
echo -e "├─────┴───┬─┴─────┴────────┴─────┴───────┴────┬──┴──────┤"
echo -e "│         │\033[37mSearch: \033[32m$search_filter    \033[36m                       │         │"
echo -e "│         └───────────────────────────────────┘         │"
echo -e "├─────┬─────────────────────────────────────────────────┤"
#echo -e "└─────┴─────────────────────────────────────────────────┘"
tput cup 16 0
echo -e "\033[36m└─────┴─────────────────────────────────────────────────┘\033[0m"
for x in $(seq 15 -1 6); do
    tput cup $x 56
    echo -e $HH
done

tput cup 6 0
    for ((i = 0; i < MAX_DISPLAY; i++)); do
        idx=$((start_index + i))
        if [[ $idx -ge $total ]]; then
            break
        fi
        if [[ $idx -eq $selected ]]; then
            echo -e "$HH \e[1m\e[36m -> $HH    ${options[$idx]}\e[0m"
        else
            echo -e "$HH     $HH    ${options[$idx]}"
        fi
    done
    tput cup 17 0

}

while true; do
    show_menu
    read -rsn3 key

    case $key in
        $'\e[A')  # Up arrow key
            if ((selected > 0)); then
                ((selected--))
            else
                selected=$((total - 1))
                start_index=$((total > MAX_DISPLAY ? total - MAX_DISPLAY : 0))
            fi
            if ((selected < start_index)); then
                ((start_index--))
            fi
            ;;

        $'\e[B')  # Down arrow key
            if ((selected < total - 1)); then
                ((selected++))
            else
                selected=0
                start_index=0
            fi
            if ((selected >= start_index + MAX_DISPLAY)); then
                ((start_index++))
            fi
            ;;
        '')  # Enter key
            clear
            echo "You selected: ${options[$selected]}"
            if [[ -z ${options[$selected]} ]]; then
                break 0
            fi
            ((COUNTER++))
            tput cup 6 0
            refresh_menu
            tput cup 0 0
			lcedit ${options[$selected]}



#            read -rsn1 -p "Press any key to continue..."
            ;;
    esac
done
#}}}
