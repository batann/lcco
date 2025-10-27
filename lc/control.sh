#!/bin/bash

# Define your control file
CONTROL_FILE="/home/$USER/.config/ls/control.file"
CONTROL_DATA="/home/$USER/.config/ls/control.data"

# Ensure control file exists and is sourced
[ -f "$CONTROL_FILE" ] || { echo "Missing: $CONTROL_FILE"; exit 1; }
source "$CONTROL_FILE"

# Create or clear the control data log
> "$CONTROL_DATA"

# Grouped categories
MEDIA_DIRS=($DIR_MEDIA $DIR_MEDIA_VIDEO $DIR_MEDIA_AUDIO)
CONFIG_DIRS=($DIR_CONFIG $DIR_CONFIG_LC $DIR_CONFIG_MISC)
OTHER_PATHS=($FILESDOT $FILESBASH $FILE_MAIN $FILE_TEMP $FILE_KEYS $FILE_REGISTERS)

# Prompt for directory creation
prompt_create_dir() {
    local path="$1"
    read -p "Directory '$path' does not exist. Create it? (y/n): " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        mkdir -p "$path" && echo "Created: $path"
    fi
}

# Prompt for file creation
prompt_create_file() {
    local path="$1"
    read -p "File '$path' does not exist. Create it? (y/n): " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        touch "$path" && echo "Created empty file: $path"
    fi
}

# Handle directories
process_directory() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        access_time=$(stat -c %x "$dir")
        echo "Directory exists: $dir (Last accessed: $access_time)"
        echo "DIR|$dir|$access_time" >> "$CONTROL_DATA"
    else
        prompt_create_dir "$dir"
    fi
}

# Handle files
process_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        mod_time=$(stat -c %y "$file")
        echo "File exists: $file (Last modified: $mod_time)"
        echo "FILE|$file|$mod_time" >> "$CONTROL_DATA"
    else
        prompt_create_file "$file"
    fi
}

echo "== Checking Media Directories =="
for d in "${MEDIA_DIRS[@]}"; do
    process_directory "$d"
done

echo
echo "== Checking Config Directories =="
for d in "${CONFIG_DIRS[@]}"; do
    process_directory "$d"
done

echo
echo "== Checking Files and Other Directories =="
for p in "${OTHER_PATHS[@]}"; do
    [[ -d "$p" ]] && process_directory "$p"
    [[ -f "$p" ]] && process_file "$p"
    [[ ! -e "$p" ]] && {
        [[ "$p" == */* ]] && {
            [[ "$p" == */.* ]] && process_file "$p" || process_directory "$p"
        }
    }
done

echo
echo "== Summary written to $CONTROL_DATA =="

