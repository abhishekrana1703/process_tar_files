#!/bin/bash

# Function to truncate username and url fields in users_000001.json file
truncate_fields() {
    local file_path="$1"
    echo "Processing file: $file_path"
    
    # Debug output: print the original JSON
    jq '.' "$file_path"
    
    # Truncate login and url fields
    jq 'map(
        if .login and (.login | length > 33) then .login = (.login | .[0:32]) else . end |
        if .url and (.url | length > 33) then .url = (.url | .[0:32]) else . end
    )' "$file_path" > tmp.$$.json && mv tmp.$$.json "$file_path"
    
    echo "Processed file: $file_path"
    
    # Debug output: print the modified JSON
    jq '.' "$file_path"
}

# Function to check and untar .tar.gz files
process_tar_files() {
    # Check for .tar.gz files in the input-files directory
    tar_files=input-files/*.tar.gz
    
    # If no .tar.gz files found, exit the script
    if [ ! -e $tar_files ]; then
        echo "No .tar.gz files found in the input-files directory."
        exit 1
    fi
    
    # Loop through each .tar.gz file
    for tar_file in input-files/*.tar.gz; do
        # Extract the base name of the file (without extension)
        base_name=$(basename "$tar_file" .tar.gz)
        
        # Create a directory with the base name
        mkdir -p "$base_name"
        
        # Extract the tar.gz file into the created directory
        tar -xzvf "$tar_file" -C "$base_name"
        
        echo "Extracted $tar_file into $base_name/"
        
        # Change to the new directory
        cd "$base_name" || exit
        
        # Check for users_000001.json file and truncate fields if necessary
        if [ -f "users_000001.json" ]; then
            echo "users_000001.json found, checking for long fields..."
            truncate_fields "users_000001.json"
        else
            echo "users_000001.json not found in $base_name/"
        fi
        
        # Go back to the original directory
        cd ..
        
        # Create a tar.gz archive of the directory
        tar -czvf "${base_name}_processed.tar.gz" "$base_name"
        echo "Created archive: ${base_name}_processed.tar.gz"
        
        # Remove the extracted directory if needed
        rm -rf "$base_name"
    done
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to run this script."
    exit 1
fi

# Call the function
process_tar_files
