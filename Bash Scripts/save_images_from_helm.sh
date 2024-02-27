#!/bin/bash

# Check if at least one argument was passed
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments supplied."
    echo "Usage: $0 helm/chart (optional --version <chart-version>)"
    exit 1
fi
chart_name="${1##*/}"
echo "$1 $chart_name"
mkdir -p $chart_name'_images'
cd $chart_name'_images'

# Get all images 
helm template $1 $2 $3 | grep 'image:' | awk '{print $2}' | tr -d '"' > images.list

# Sort and remove duplicates
sort images.list | uniq > temp_file.list
mv temp_file.list images.list

# Path to the file containing the docker image names
FILE_PATH="images.list"

# Loop through each line in the file
while IFS= read -r image; do
  echo "Pulling $image..."
  # Pull the docker image
  docker pull "$image"

  # Replace '/' with '_' in image name for the filename
  filename=$(echo "$image" | tr '/' '_')

  echo "Saving $image to ${filename}.tar..."
  # Save the docker image to a tar archive
  docker save -o "${filename}.tar" "$image"
done < "$FILE_PATH"

echo "Process completed."