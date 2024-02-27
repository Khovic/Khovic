#!/bin/bash

pack_npms() {
    pwd
    ls -l
    for service in "${services_list[@]}"; do
        echo $service
        cd $baseFolder/dependencies_temp
        cd $source_code_folder/$service
        npm install --force

        # Initialize an empty array
        dependencies=()

        # Loop through each line of the command output and add to the array
        while IFS= read -r line; do
            dependencies+=("$line")
        done < <(npm list -a | grep -o '[a-zA-Z@].*' | awk '{print $1}')

        cd $baseFolder/dependencies_temp
        mkdir -p npm_deps 
        cd npm_deps

        # Print the array content (for verification)
        echo "Dependencies:"
        for dep in "${dependencies[@]}"; do
            echo "$dep"
            npm pack $dep
        done
    done
}

# Convert git project url to ssh url for cloning entire git project
convert_url() {
    local input_url=$git_code_repo

    # Replace 'https://' with 'git@'
    local temp_url="${input_url/https:\/\//git@}"

    # Insert a colon after the domain name
    local domain_end_index=$(expr index "$temp_url" /)
    local git_url="${temp_url:0:domain_end_index-1}:${temp_url:domain_end_index}"

    # Ensure there's a trailing slash
    [[ "$git_url" != */ ]] && git_url="$git_url/"

    echo "$git_url"
}

# Pull Source code from git
git_save_source_code() {
    local output_url=$(convert_url "$git_code_repo")

    mkdir -p "source_code"
    for service in "${services_list[@]}"; do
        git clone --recurse-submodules git@$git_code_repo/$service.git source_code/$service
    done
}

# Saves all files to an archive
create_archive() {
    cd $baseFolder/dependencies_temp/
    local archive_name="packed_npms"
    shift # Remove the first argument
    local folders_to_archive="npm_deps"
    
    # Create the tar.gz archive
    tar -czvf "$archive_name.tar.gz" $folders_to_archive

    echo "Archive $archive_name.tar.gz created with the following folders: ${folders_to_archive[*]}"
    
    mv "$archive_name.tar.gz" ..
    cd $baseFolder
}


main() {
    git_code_repo='https://<repo-containing-src-code>'
    services_list=("service-1" "service-2")
    source_code_folder='source_code'

    baseFolder=$(pwd)

    mkdir -p dependencies_temp
    cd $baseFolder/dependencies_temp

    ##### SERVICES LIST INPUT START #####
    echo "default list:"
    for service in "${services_list[@]}"; do
        echo "$service"
    done
    echo "Enter the names of services separated by spaces (or press Enter to use the default list):"
    read -r user_input

    if [[ -z "$user_input" ]]; then
        # User input is empty, use the default list
        echo "No input provided. Using the default services list."
        services_list=("${services_list[@]}")
    else
        # Split the user input into an array
        read -ra services_list <<< "$user_input"
        echo "Using the entered services list."
    fi

    echo "Services: ${services_list[*]}"
    ##### SERVICES LIST INPUT END #####

    git_save_source_code 

    pack_npms

    create_archive

    # rm -rf npm_deps
}


main