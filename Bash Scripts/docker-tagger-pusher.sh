#!/bin/bash

# Check if a parameter is given (new repository URL)
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <new-repo-url>"
    exit 1
fi

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

    # Prepare the new tag by appending the new repository URL to the image name
    new_tag="${new_repo_url}/${image_name_and_tag##*/}"

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
