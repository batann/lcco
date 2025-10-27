#!/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker#

dayplanner() {
cat /home/$USER/.lcco/calendar/dayplanner.md    
}


dayplanner >> dayplanerr.md
REM_NUM="$(cat ~/.reminder.rem |grep $(date +%Y-%m-%d)|cut -c40-48|wc -l)"
for i in $(seq 1 $REM_NUM); do
x="$(cat ~/.reminder.rem |grep $(date +%Y-%m-%d)|cut -c40-41|head -n${i})"
LINETOAPPENDTO=$(( $(( $x - 6 )) * 3 ))
MSSG=$(cat ~/.reminder.rem |grep "$(date +%Y-%m-%d)"|grep "T${x}"|cut -c60-75)
sed "${LINETOAPPENDTO}{/^$/s/^$/${MSSG}/}" dayplanner.md
done




#for x in $(cat ~/.reminder.rem |grep $(date +%Y-%m-%d)|cut -c40-42); do

#for i in $(seq 1 11); do
#	x=$(task ${i}|grep Due|awk '{print $3}'|cut -c1-2|head -n1)
#	x=$(task 4|grep Due|awk '{print $3}'|cut -c1-2|head -n1)
#LINETOAPPENDTO=$(( $(( $x - 6 )) * 3 ))
#DESCRIPTION=$(task 4|grep Description|awk '{print $2,$3,$4,$5}')
#sed "${LINETOAPPENDTO}{/^$/s/^$/${DESCRIPTION}/}" dayplanner.md
#done
