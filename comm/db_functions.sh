#!/bin/bash
# Database functions - work directly with SQLite to avoid character issues

DB_PATH="/home/$USER/.lcco/comm/database.db"

# Get basic command by ID
get_basic_command() {
    local id="$1"
    sqlite3 "$DB_PATH" "SELECT command FROM BasicCommand WHERE id = $id;"
}

# Get command name by ID
get_command_name() {
    local id="$1"
    sqlite3 "$DB_PATH" "SELECT name FROM Command WHERE id = $id;"
}

# Search basic commands
search_basic_commands() {
    local search_term="$1"
    sqlite3 "$DB_PATH" "SELECT id, SUBSTR(command, 1, 50) || '...' as preview FROM BasicCommand WHERE command LIKE '%$search_term%';"
}

# List all categories
list_categories() {
    sqlite3 "$DB_PATH" "SELECT id, title FROM BasicCategory ORDER BY position;"
}

# Get random basic command
get_random_basic_command() {
    sqlite3 "$DB_PATH" "SELECT id, SUBSTR(command, 1, 100) || '...' as preview FROM BasicCommand ORDER BY RANDOM() LIMIT 1;"
}

# Count records in each table
show_stats() {
    echo "Database Statistics:"
    echo "Basic Commands: $(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM BasicCommand;")"
    echo "Commands: $(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM Command;")"
    echo "Basic Groups: $(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM BasicGroup;")"
    echo "Categories: $(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM BasicCategory;")"
    echo "Tips: $(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM Tip;")"
    echo "Command Sections: $(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM CommandSection;")"
    echo "Tip Sections: $(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM TipSection;")"
}

# Get commands by category
get_commands_by_category() {
    local category_id="$1"
    sqlite3 "$DB_PATH" "
    SELECT bc.id, SUBSTR(bc.command, 1, 50) || '...' as preview
    FROM BasicCommand bc
    JOIN BasicGroup bg ON bc.group_id = bg.id
    WHERE bg.category_id = $category_id
    LIMIT 10;"
}

# Interactive command browser
browse_commands() {
    echo "=== Command Browser ==="
    echo "Categories available:"
    list_categories
    echo
    read -p "Enter category ID to browse (or 'q' to quit): " category_id

    if [[ "$category_id" == "q" ]]; then
        return
    fi

    echo "Commands in category $category_id:"
    get_commands_by_category "$category_id"
    echo
    read -p "Enter command ID to view full content (or 'q' to quit): " cmd_id

    if [[ "$cmd_id" == "q" ]]; then
        return
    fi

    echo "Full command content:"
    get_basic_command "$cmd_id"
}
