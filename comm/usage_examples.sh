#!/bin/bash
# Usage examples for the extracted database

# Source the functions
source /home/$USER/.lcco/comm/db_functions.sh

echo "=== Database Usage Examples ==="
echo

# Show statistics
show_stats
echo

# Show some categories
echo "Available categories:"
list_categories
echo

# Show a random command
echo "Random command preview:"
get_random_basic_command
echo

# Search example
echo "Searching for commands containing 'adventure':"
search_basic_commands "adventure"
echo

echo "To browse commands interactively, run: source db_functions.sh && browse_commands"

# Example of reading CSV with bash
echo "Reading categories from CSV:"
while IFS=',' read -r id position title; do
    if [[ "$id" != "id" ]]; then  # skip header
        echo "Category $id: $title"
    fi
done < /home/$USER/.lcco/comm/basic_categories.csv
