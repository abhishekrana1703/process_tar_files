#!/bin/bash

# Check if any ".tar.gz" file is available in the current directory
tar_file=$(ls *.tar.gz 2>/dev/null | head -n 1)
if [ -z "$tar_file" ]; then
    echo "No .tar.gz file found in the current directory."
    exit 1
fi

# Create a folder with the name of the file (without extension)
folder_name="${tar_file%.tar.gz}"
mkdir -p "$folder_name"

# Unzip the file into the new folder
tar -xzf "$tar_file" -C "$folder_name"

# Navigate into the folder where the file has been extracted
cd "$folder_name" || exit 1

# Check if users_000001.json and teams_000001.json files are present
if [ -f "users_000001.json" ] && [ -f "teams_000001.json" ]; then
    # Process users_000001.json
    users_json="users_000001.json"
    # Define the specific user record to keep
    specific_user='{"type":"user","url":"https://gitlab.com/Lik.X.Kwan","login":"Lik.X.Kwan","name":"Kwan, Lik X","company":null,"website":null,"location":null,"emails":[],"created_at":null}'
    # Replace the content with the specific user record, keeping only that entry
    echo "[$specific_user]" > "$users_json"

    # Process teams_000001.json
    teams_json="teams_000001.json"
    # Check if the JSON file is an array or object and select the first record
    jq 'if type == "array" then .[0] else . end' "$teams_json" > tmp_teams.json
    mv tmp_teams.json "$teams_json"

    # Go back to the parent directory
    cd ..

    # Create a new tar.gz file with folder name and timestamp
    timestamp=$(date +"%Y%m%d%H%M%S")
    tar -czf "${folder_name}_${timestamp}.tar.gz" "$folder_name"
    
    # Delete the extracted folder to clean up
    rm -rf "$folder_name"
    
    echo "Processed and created archive: ${folder_name}_${timestamp}.tar.gz"
else
    echo "Either users_000001.json or teams_000001.json not found in the folder."
    exit 1
fi
