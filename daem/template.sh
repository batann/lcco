#!/bin/bash
#}}}
#{{{ enable folds and credentials
# vim:fileencoding=utf-8:foldmethod=marker
#}}}
#{{{ variables and housekeeping
CACHE="/home/$USER/.lcco/cache/da"
if [ ! -d == "$CACHE" ]; then
    mkdir -p $CACHE
fi
DIRBASE="/home/$USER/.lcco/daem"
DIRCACHE="/home/$USER/.lcco/cache/da"
DIRLOG="$DIRCACHE/log"
DIRPID="$DIRCACHE/pid"
FILEPID="$DIRPID/$FILE"
STAMP="$(date +%j.%H.%M)"
COLS="";AA="─";BB=""; for x in $(seq 1 $(tput cols)); do COLS="${COLS}${AA}" ;done
DAEMON_FUNCS="/home/$USER/.lccc/daem/daemon_functions"
#}}}
#{{{ tty-wrap
tty-wrap() {
    tput civis
    stty -echo -icanon time 0 min 0 < /dev/tty
    trap 'stty sane < /dev/tty; tput cnorm' EXIT INT TERM HUP
}
#}}}


#{{{ Load daemon function definitions
[[ -f "$DAEMON_FUNCS" ]] || {
    echo "Missing $DAEMON_FUNCS"
    exit 1
}
source "$DAEMON_FUNCS"
#}}}
#{{{ Periodic function list
PERIODIC_FUNCS=(
    check_update
    remove_cache_png
    browser_history_to_list
    announce_time
    #notification_to_user
)
#}}}
#{{{ Ongoing function list (run as background persistent loops)
ONGOING_FUNCS=(
    clipboard_logic
    clipboard_gutenberg
    #version_lcbash

)
#}}}
#{{{ Log function (optional)
log() {
    printf "[%s] %s\n" "$(date '+%F %T')" "$*" >> /tmp/lcdaemon.log
}
#}}}
#{{{ --- Periodic Task Runner ---
run_periodic() {
    while true; do
        for func in "${PERIODIC_FUNCS[@]}"; do
            if declare -f "$func" > /dev/null; then
                log "Running periodic: $func"
                "$func" &
            else
                log "Missing function: $func"
            fi
        done
        wait  # Wait for all above to finish before sleeping
        sleep 1800  # 30 minutes
    done
}
#}}}
#{{{ --- Ongoing Background Tasks ---
run_ongoing() {
    for func in "${ONGOING_FUNCS[@]}"; do
        if declare -f "$func" > /dev/null; then
            log "Starting ongoing: $func"
            (
                while true; do
                    "$func" || log "Crash in $func; retrying in 5s"
                    sleep 5
                done
            ) &
        else
            log "Missing function: $func"
        fi
    done
}
#}}}
#{{{ --- Entrypoint ---
main() {
    log "Daemon starting..."
    run_ongoing
    run_periodic
}
#}}}
main




