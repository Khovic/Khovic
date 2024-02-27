#!/bin/bash

# This function removes all helms that are not in services_list list
reduce_helms() {
    local helm_dir=$1
    shift
    local keep_list=("$@")

    # Loop through each folder in the specified directory
    for folder in "./$helm_dir/"*/; do
        # Extract just the folder name without the path
        folder_name=$(basename "$folder")

        # Check if the folder is in the services_list list
        if [[ ! " ${services_list[@]} " =~ " ${folder_name} " ]]; then
            # If not in services_list list, delete it
            echo "Deleting $folder..."
            rm -rf "$folder"
        fi
    done

    # delete git folder
    rm -rf $helm_dir/.git
}

# Function to extract appVersion from chart.yaml in a specified service folder
extract_app_images() {
    local helm_dir=$1
    shift # Remove the first argument and shift the others to the left
    local services=("$@") # The rest of the arguments are service names
    local image_list=() # The list will contain the URL of all images

    for service_name in "${services[@]}"; do
        local chart_file="${helm_dir}/${service_name}/Chart.yaml"
        local values_file="${helm_dir}/${service_name}/values.yaml"

        # Check if the Chart.yaml file exists
        if [[ -f "$chart_file" ]]; then
            # Extract the appVersion value
            local app_version=$(grep 'appVersion:' "$chart_file" | cut -d ':' -f2 | xargs)
        else
            echo "Chart.yaml not found in ${service_name}"
            continue # Skip to the next iteration of the loop
        fi

        # Check if the values.yaml file exists
        if [[ -f "$values_file" ]]; then
            # Extract the baseFolder value
            local baseFolder=$(grep 'baseFolder:' "$values_file" | cut -d ':' -f2 | xargs)
        else
            echo "values.yaml not found in ${service_name}"
            continue # Skip to the next iteration of the loop
        fi

        image_name="${image_repo}/${baseFolder}${service_name}:${app_version}"
        image_list+=("$image_name")
        echo $image_name
    done
}

# Converts docker image url to a file.tar name for saving
convert_image_to_filename() {
    local input_string=$1

    # Extract the part after the last slash
    local last_part=${input_string##*/}

    # Replace colon ':' with dot '.'
    local formatted_string=${last_part/:/.}

    # Append '.tar' to the string
    echo "${formatted_string}.tar"
}

# Convert git project url to ssh url for cloning entire git project
convert_url() {
    local input_url=$1

    # Replace 'https://' with 'git@'
    local temp_url="${input_url/https:\/\//git@}"

    # Insert a colon after the domain name
    local domain_end_index=$(expr index "$temp_url" /)
    local git_url="${temp_url:0:domain_end_index-1}:${temp_url:domain_end_index}"

    # Ensure there's a trailing slash
    [[ "$git_url" != */ ]] && git_url="$git_url/"

    echo "$git_url"
}


# Function to pull and save docker images that are in $image_list
save_docker_images() {
    mkdir -p "docker_images"
    image_repo=$1
    shift # Remove the first argument
    local image_list=("$@")

    docker logout $image_repo
    echo "################## ATTENTION ##################"
    echo "##LOGIN REQUIRED, MAKE SURE TO CHECK YOUR 2FA##"
    echo "###### Enter Docker Login Credentials: ########"
    docker login $image_repo
    for image in "${image_list[@]}"; do
        file_name=$(convert_image_to_filename "$image")

        echo "pulling $image"
        docker pull $image

        echo "saving $image to docker_images/$file_name $image"
        docker save -o docker_images/$file_name $image
    done
}

# Pull Source code from git
git_save_source_code() {
    local code_repo=$1
    shift # Remove the first argument
    local services_list=("$@")
    local output_url=$(convert_url "$code_repo")

    mkdir -p "source_code"
    for service in "${services_list[@]}"; do
        git clone --recurse-submodules $code_repo/$service.git source_code/$service
    done
}

# Pull Helms from git
git_save_helms() {
    local helm_repo=$1
    git clone $helm_repo
}

prepare_for_archiving() {
    echo "Final preparations for archiving"
    echo "Removing .git from repositories"
    find ./ -name ".git" | xargs rm -rf 
    echo "Changing permissions"
    find ./ | xargs chmod 775
    echo "Permissions set to 775 on all files"
}

# Saves all files to an archive
create_archive() {
    local archive_name=$1
    shift # Remove the first argument
    local folders_to_archive=("$@")

    # Create the tar.gz archive
    tar -czvf "$archive_name.tar.gz" "${folders_to_archive[@]}"

    echo "Archive $archive_name.tar.gz created with the following folders: ${folders_to_archive[*]}"
}

main_function() {
    # Required information
    image_repo='<-default-image-repository-here->'
    git_code_repo='<-default-source-code-git-repository-here->'
    git_helms_repo='<-default-helm-charts-git-repository-here->'

    # # List of services to update (as folder names from git-helms-repository/)
    services_list=("default-service-1" "default-service-2" "default-service-3")

    # Check if the script is run as root
    if [[ $(id -u) -ne 0 ]]; then
        echo "This script must be run as root. Please use sudo or log in as root."
        exit 1
    fi

    echo "Welcome to Giga Packer 10000"

    ##### IMAGE REPOSITORY INPUT START #####
    clear
    echo "Please make sure you have permissions to pull from image repository"
    read -p "Please enter image repository url (leave empty for default: $image_repo): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        image_repo="$user_input"
        echo "Input registered: $image_repo"
    else
        echo "No input provided. $image_repo configured"
    fi
    ##### IMAGE REPOSITORY INPUT END #####

    ##### SOURCE CODE GIT URL INPUT START #####
    clear
    read -p "Please enter project source code https URL (leave empty for default: $git_code_repo): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        git_code_repo="$user_input"
        echo "Input registered: $git_code_repo"
    else
        echo "No input provided. $git_code_repo configured"
    fi
    ##### SOURCE CODE GIT URL INPUT END #####


    ##### GIT SSH URL INPUT START #####
    clear
    echo "Please make sure you have configured SSH Access to git on this computer"
    read -p "Please helms ssh url (leave empty for default: $git_helms_repo): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        git_helms_repo="$user_input"
        echo "Input registered: $git_helms_repo"
    else
        echo "No input provided. $git_helms_repo configured"
    fi
    helm_dir=${git_helms_repo%.git} # removes .git
    helm_dir=${helm_dir##*/} # takes the string after the last "/"
    tar_name=${git_code_repo##*/}
    ##### GIT SSH URL INPUT END #####
    

    ##### HELMS URL INPUT START #####
    clear
    read -p "Please helms ssh url (leave empty for default: $git_helms_repo): " user_input
    if [[ -n "$user_input" ]]; then
        # -n tests if the string is non-empty
        git_helms_repo="$user_input"
        echo "Input registered: $git_helms_repo"
    else
        echo "No input provided. $git_helms_repo configured"
    fi
    ##### HELMS URL INPUT END #####

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


    # Save Helms
    git_save_helms "$git_helms_repo"

    # Save Source_code
    git_save_source_code "$git_code_repo" "${services_list[@]}"

    # Call the function with directory and services_list as keep list
    reduce_helms "$helm_dir" "${services_list[@]}"

    # Creates an 'image_list' array from extract_app_images
    readarray -t image_list < <(extract_app_images "$helm_dir" "${services_list[@]}")

    # Pass image_list to the function for pulling an saving
    save_docker_images "$image_repo" "${image_list[@]}"

    # Prepare for archiving, remove .git and chmod on all files to be packed
    prepare_for_archiving

    # Save all to a tar.gz archive
    create_archive "$tar_name" "docker_images" "helms-folder" "source_code"

    # Clear Files after packing
    
    if [[ -n $helms_dir ]]; then
        echo "Deleting folders"
        rm -rf $helm_dir/ docker_images/ source_code/
    else
        echo "variable is empty"
    fi
}

main_function