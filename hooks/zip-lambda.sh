#!/bin/bash

folder_to_zip="files/self-signed-certificate-lambda"
zip_file="files/self-signed-certificate-lambda.zip"
hash_file="files/self-signed-certificate-lambda-hash.txt"

# create zip in specified path
zip -r "$zip_file" "$folder_to_zip"

# calculate sha256 from zip file
lambda_zip_code_hash=$(sha256sum "$zip_file" | awk '{print $1}')

# store hash value
echo "$lambda_zip_code_hash" > "$hash_file"

# if hash changed, then zip changed too
if [[ `git status --porcelain "$hash_file"` ]]; then
    # add and commit changes
    git add $hash_file
    git add $zip_file
else
    # No changes
    echo "No changes have been made to self-signed-certificate-lambda files"
fi

exit 0