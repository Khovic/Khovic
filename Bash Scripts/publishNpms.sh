#!/bin/bash
mkdir -p deps_temp
cp *npm*.tar.gz deps_temp/
cd deps_temp
tar -xzvf *npm*.tar.gz

find ./ -name "*.tgz" | while IFS= read -r file; do
    echo "Publishing $file"
    publish_output=$(npm publish "$file" 2>&1)

    if [[ $? -eq 0 ]]; then
    # Publish succeeded
        echo "Publishing succeeded"
    else 
        # Check if Package already exists
        if [[ $publish_output == *"403"* ]]; then
            echo "Publish retruned 403, Likely package already exists in the Repository"
            rm -rf $file
        else
            echo "Publish failed due to unknown error"
            echo "$publish_output"
            echo "Retrying with package.json modifications"

            tar -xvzf $file
            cd package
            jq 'del(.publishConfig)' package.json > tmp.json
            jq 'del(.private)' tmp.json > tmp2.json
            mv tmp2.json package.json
            
            publish_output=$(npm publish "$file" 2>&1)
            cd ..
            if [[ $? -eq 0 ]]; then
            # Publish succeeded
                echo "Publishing succeeded"
                rm -rf $file
                rm -rf package
            else 
                # Check if Package already exists
                if [[ $publish_output == *"403"* ]]; then
                    echo "Publish retruned 403, Likely package already exists in the Repository"
                    rm -rf $file
                    rm -rf package
                else
                    echo "Publish failed due to unknown error"
                    echo "$publish_output"  
                fi
            fi
        fi
    fi
done
cd ..
rm -rf deps_temp
