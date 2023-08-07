#!/bin/bash

file_to_zip="index.py"
zip_file="self-signed-certificate-lambda.zip"
hash_file="self-signed-certificate-lambda-hash.txt"

cd files/self-signed-certificate-lambda || exit

# create zip in specified path
zip "../$zip_file" "$file_to_zip"

cd ..

# calculate sha256 from zip file
lambda_zip_code_hash=$(sha256sum "$zip_file" | awk '{print $1}')

# store hash value
echo "$lambda_zip_code_hash" > "$hash_file"

# if hash changed, then zip changed too
if [[ $(git status --porcelain "$hash_file") ]]; then
    # add and commit changes
    git add $hash_file
    git add $zip_file
    echo "Updated self-signed-certificate-lambda files"
else
    # No changes
    echo "No changes have been made to self-signed-certificate-lambda files"
fi

exit 0