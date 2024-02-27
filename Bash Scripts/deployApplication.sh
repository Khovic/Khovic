#!/bin/bash

# Variables provided externally, ENV dependent
archive_name="<-tar.gz file created by pack_application->"
docker_destination='<-destination-docker-repo->'
source_code_dir='source_code'
image_dir='docker_images'
helms_dir='name-of directory containing helm charts'
helms_git_repo='git@<target-git-for-helm-charts>.git' # 
source_code_git_repo='<target-git-for-source-code>'
enable_source_code_update='no'

# Variables to be used internally by the script
base_directory=$(pwd)
updated_services_list=()
updated_source_code_list=()

mkdir -p temp/
mkdir -p temp/fromLocalENV


tag_and_push_docker() {
    # Check if a parameter is given (new repository URL)
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <new-repo-url>"
        exit 1
    fi

    cd ./temp/$image_dir

    # New repository URL provided as parameter
    new_repo_url=$1
    # Array to hold new tags
    declare -a new_tags

    # Function to load, tag, and push docker images
    load_tag_push() {
        image_tar=$1
        # Load the Docker image
        load_output=$(docker load -i "${image_tar}")

        # Extract the image name and tag from the load output
        image_name_and_tag=$(echo "${load_output}" | grep -oP '(?<=Loaded image: ).*')

        # If image name and tag is empty, try to find the image ID
        if [ -z "$image_name_and_tag" ]; then
            image_name_and_tag=$(echo "${load_output}" | grep -oP '(?<=Loaded image ID: ).*')
            if [ -z "$image_name_and_tag" ]; then
                echo "Error: Could not determine image name and tag from 'docker load' output."
                return 1
            fi
        fi

        # Extract the image folder
        image_folder=${image_name_and_tag%/*}
        image_folder=${image_folder##*/}

        # Prepare the new tag by appending the new repository URL to the image name
        new_tag="${new_repo_url}/${image_folder}/${image_name_and_tag##*/}"

        # Tag the image with the new repository URL and tag
        docker tag "${image_name_and_tag}" "${new_tag}"

        # Push the image to the new repository
        docker push "${new_tag}"

        # Add new tag to array
        new_tags+=("${new_tag}")
    }

    # Loop over each .tar file in the working directory
    for image_tar in *.tar; do
        if [[ -f "$image_tar" ]]; then
            echo "Processing $image_tar..."
            if ! load_tag_push "$image_tar"; then
                echo "Failed to process $image_tar"
                exit 1
            fi
        else
            echo "No .tar files found in the working directory."
            exit 1
        fi
    done

    echo "All images have been processed."

    # Print out all new tags
    echo "New tags for all processed images:"
    for tag in "${new_tags[@]}"; do
        echo "$tag"
    done

    cd $base_directory
    pwd
}

# extract tar.gz archive created by the packing script 
extract_archive() {
    echo "Extracting Archive"
    archive_name=$1
    mkdir -p temp 
    cp $archive_name temp/
    cd temp 
    tar -xvzf $archive_name
    cd $base_directory
    echo "Archive extracted successfuly"
}

# Locates helms located in $helms_dir, every folder is considered a newly updated service
scan_updated_helms() {
    echo "Scanning for updated services ..."
    local path="$base_directory/temp/$helms_dir/"

    # Loop through each folder within $path to scan for updated services
    while IFS= read -r -d '' folder; do 
        # Extract folder names (updated services) in $path
        folder_name=$(basename "$folder")
        updated_services_list+=("$folder_name")
    done < <(find "$path" -mindepth 1 -maxdepth 1 -type d -print0) 
    echo "Found services: ${updated_services_list[@]}"
}

# Locates code located in $code_dir, every folder is considered a newly updated service
scan_updated_code() {
    echo "Scanning for updated services ..."
    local path="$base_directory/temp/$source_code_dir/"

    # Loop through each folder within $path to scan for updated services
    while IFS= read -r -d '' folder; do 
        # Extract folder names (updated services) in $path
        folder_name=$(basename "$folder")
        updated_source_code_list+=("$folder_name")
    done < <(find "$path" -mindepth 1 -maxdepth 1 -type d -print0) 
    echo "Found source_code: ${updated_source_code_list[@]}"
}


# Clone local helms
clone_helms_repo() {
    echo "Cloning local env helms repo"
    # helms_git_repo=$1
    local repo_name=$(basename -s .git "$helms_git_repo")
    cd temp/fromLocalENV
    git clone $helms_git_repo  
    echo $repo_name 
    cd $base_directory
}

# Updated local helms with new helms
update_helms() {
    pwd
    echo "deleting nad.yaml, values.yaml files from new helms ..."
    find temp/$helms_dir/ -name "values.yaml" | xargs rm -rf
    find temp/$helms_dir/ -name "NAD*" | xargs rm -rf
    find temp/$helms_dir/ -name "hydra_config*" | xargs rm -rf
    find temp/$helms_dir/ -name "gc_config*" | xargs rm -rf
    find temp/$helms_dir/ -name "simulator_config*" | xargs rm -rf

    echo "overwriting old helms with new ones ..."
    cp -r temp/$helms_dir/* temp/fromLocalENV/$helms_dir/
    cd temp/fromLocalENV/$helms_dir/
    git add .
    git commit -m "Updated by deployScript.sh"
    git push
    cd $base_directory
}

# Convert git project url to ssh url for cloning entire git project
convert_url() {
    local input_url=$source_code_git_repo

    # Replace 'https://' with 'git@'
    local temp_url="${input_url/https:\/\//git@}"

    # Insert a colon after the domain name
    local domain_end_index=$(expr index "$temp_url" /)
    git_url="${temp_url:0:domain_end_index-1}:${temp_url:domain_end_index}"

    # Ensure there's a trailing slash
    [[ "$git_url" != */ ]] && git_url="$git_url/"

    echo "$git_url"
}

set_vars() {
    ##### ARCHIVE NAME INPUT START #####
    clear
    read -p "Please enter Archive name (leave empty for default: $archive_name): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        archive_name="$user_input"
        echo "Input registered: $archive_name"
    else
        echo "No input provided. $archive_name configured"
    fi
    ##### ARCHIVE NAME INPUT END #####

    ##### docker_destination INPUT START #####
    clear
    read -p "Please enter docker_destination repository (leave empty for default: $docker_destination): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        docker_destination="$user_input"
        echo "Input registered: $docker_destination"
    else
        echo "No input provided. $docker_destination configured"
    fi
    ##### docker_destination INPUT END #####

    ##### image_dir INPUT START #####
    clear
    read -p "Please enter image_dir repository (leave empty for default: $image_dir): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        image_dir="$user_input"
        echo "Input registered: $image_dir"
    else
        echo "No input provided. $image_dir configured"
    fi
    ##### image_dir INPUT END #####

    ##### helms_dir INPUT START #####
    clear
    read -p "Please enter helms_dir repository (leave empty for default: $helms_dir): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        helms_dir="$user_input"
        echo "Input registered: $helms_dir"
    else
        echo "No input provided. $helms_dir configured"
    fi
    ##### helms_dir INPUT END #####

    ##### helms_git_repo INPUT START #####
    clear
    read -p "Please enter helms_git_repo repository (leave empty for default: $helms_git_repo): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        helms_git_repo="$user_input"
        echo "Input registered: $helms_git_repo"
    else
        echo "No input provided. $helms_git_repo configured"
    fi
    ##### helms_git_repo INPUT END #####

    ##### Update Source Code INPUT START #####
    clear
    read -p "Would you like to update and push source code to git? (leave empty for default: $enable_source_code_update): " user_input
    if [[ "$user_input" == "yes" ]]; then
        # -n tests if the string is non-empty
        enable_source_code_update="$user_input"
        echo "Input registered: $enable_source_code_update"
    else
        echo "No input provided. $enable_source_code_update configured"
    fi
    ##### Update Source Code INPUT END #####

}

# Pull Source code from git
git_save_source_code() {

    output_url=$(convert_url "$code_repo")
    mkdir -p "./temp/fromLocalENV/$source_code"
    for service in "${updated_source_code_list[@]}"; do
        echo $service
        git clone --recurse-submodules git@$git_url$service.git ./temp/fromLocalENV/$source_code_dir/$service
    done
}

# Update the source code and push to git
update_source_code() {
    # delete following files files
    find ./temp/$source_code_dir/ -name "pip.conf" | xargs rm -rf
    find ./temp/$source_code_dir/ -name ".npmrc" | xargs rm -rf
    find ./temp/$source_code_dir/ -name "Dockerfile" | xargs rm -rf
    find ./temp/$source_code_dir/ -name "package-lock.json" | xargs rm -rf
    find ./temp/$source_code_dir/ -name ".git" | xargs rm -rf

    for service in "${updated_source_code_list[@]}"; do
        cd $base_directory
        echo $service
        cp -r ./temp/$source_code_dir/$service/*  ./temp/fromLocalENV/$source_code_dir/$service/
        cd ./temp/fromLocalENV/$source_code_dir/$service/
        git add .
        git commit -m "updated by deployScript.sh"
        git push
        cd $base_directory
    done

}

main() {
    # Set Variables for deployment
    set_vars

    # Extract .tar.gz archive created by packing script
    extract_archive $archive_name

    # Load images from the extracted $images_dir folder
    tag_and_push_docker "$docker_destination" "$image_dir"

    # Scan $helms_dir for newly updated services
    scan_updated_helms

    # Clone $helms_git_repo to ./temp/fromLocalENV/
    clone_helms_repo

    # Updates helms with helms from ./temp/$helms_dir
    update_helms

    # Convert Git HTTPS URL to SSH compatipble URL
    convert_url

    # Scans $source_code_dir as extracted from the archive to find updated code
    scan_updated_code

    
    # Clones from $source_code_git_repo according to $updated_source_code_list for updating
    git_save_source_code

    # Updates Source code and pushes to git
    if [[ "$enable_source_code_update" == "yes" ]]; then
        echo "Updating Source Code"
        update_source_code
    else
        echo "Skipping Source code update"
    fi
    

    # Delete temp folder
    rm -rf temp

    echo "all changes were committed"
}

main
