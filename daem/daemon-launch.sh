#!/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker



#{{{ variables and housekeeping
CACHE="/home/$USER/.lcco/cache/da"
if [ ! -d == "$CACHE" ]; then
    mkdir -p $CACHE
fi
DIRBASE="/home/$USER/.lcco/LC/daem"
if [ ! -d == "$DIRBASE" ]; then
    mkdir -p $DIRBASE
fi

DIRCACHE="/home/$USER/.lcco/cache/da"
if [ ! -d == "$DIRCACHE" ]; then
    mkdir -p $DIRCACHE
fi

DIRLOG="$DIRCACHE/log"
if [ ! -d == "$DIRLOG" ]; then
    mkdir -p $DIRLOG
fi

DIRPID="$DIRCACHE/pid"
if [ ! -d == "$DIRPID" ]; then
    mkdir -p $DIRPID
fi



FILEPID="$DIRPID/$FILE"
STAMP="$(date +%j.%H.%M)"
COLS="";AA="─";BB=""; for x in $(seq 1 $(tput cols)); do COLS="${COLS}${AA}" ;done
DAEMON_FUNCS="/home/$USER/.lccc/daem/daemon_functions"
#}}}


source "$DIRBASE/lc-*"  # <- this file defines all your functions


# --- Background long-running services ---
start_service() {
    local name="$1"
    shift
    "$name" "$@" &
    echo $! > "$DIRPID/${name}.pid"
}

#start_service listen_clipboard
#start_service listen_tts_dir
#start_service announce_time
start_service lc-backup-bash-history
start_service lc-backup-bookmarks
#start_service lc-backup-browser-history
start_service lc-bind-capslock
start_service lc-clipboard_logic
start_service lc-set-wallpaper

# --- Periodic tasks ---
start_periodic() {
    local name="$1" interval="$2"
    shift 2
    (
        while true; do
            "$name" "$@"
            sleep "$interval"
        done
    ) &
    echo $! > "$DIRPID/${name}.pid"
}



start_periodic lc-backup-browser-history 600
#start_periodic taskwarrior_sync 600      # every 10 min
#start_periodic rss_parse        900      # every 15 min
#start_periodic podcast_parse    1800     # every 30 min
#start_periodic config_sync      3600     # every hour
#start_periodic cleanup          21600    # every 6 hours
#start_periodic backup_browser   86400    # daily
#start_periodic feh_background   86400    # daily (if needed)

echo "Daemon processes started."

