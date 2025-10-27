#!/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker

#{{{ >>>   housekeeping
DIRBASE="/home/$USER/.lcco/cale"
if [[ ! -d "$DIRBASE" ]]; then
	mkdir -p "$DIRBASE"
fi
DIRCACHE="/home/$USER/.lcco/cache/cale"
if [[ ! -d "$DIRCACHE" ]]; then
	mkdir -p "$DIRCACHE"
fi
DIRLOG="$DIRCACHE/log"
if [[ ! -d "$DIRLOG" ]]; then
	mkdir -p "$DIRLOG"
fi
STAMP="$(date +%j.%H.%M)"
FILECONFIG="/home/$USER/.lcco/LC/config"
FILELOG="$DIRLOG/$STAMP.log"
FILEREMINDER="/home/batan/.lcco/cale/reminder.rem"
#}}}

#{{{ >>>   CAL_DISPLAY



dis_cal() {
	echo -e "\033[1;35m────────────────────\033[0m"
	cal| GREP_COLORS='mt=01;36' grep --color=always -E "Su Mo Tu We Th Fr Sa |$"| GREP_COLORS='mt=01;32' grep --color=always -E "$(date +%d)|$"|GREP_COLORS='mt=01;31' grep --color=always -E "$(cat "$FILEREMINDER" |cut -c13-14|sort -u) $DAYRMD|$"
	echo -e "\033[1A\033[1;35m────────────────────\033[0m"
}
#}}}

dis_cal








read -rsn2 input
if [[ "$input" =~ ^[0-9]{1,2}$ ]]; then
  SELECTED_DAY=$input
fi



GREP_COLORS='mt=01;41' grep --color=always -E "$SELECTED_DAY|$"
SELECTED_DAY=$(date +%d)

while true; do
  echo -e "\033[9A"
  dis_cal
  read -rsn1 key
  case "$key" in
    A) SELECTED_DAY=$((SELECTED_DAY - 7)) ;;
    B) SELECTED_DAY=$((SELECTED_DAY + 7)) ;;
    C) SELECTED_DAY=$((SELECTED_DAY + 1)) ;;
    D) SELECTED_DAY=$((SELECTED_DAY - 1)) ;;
    [0-9]) SELECTED_DAY=$key ;;
    q) break ;;
  esac
done

