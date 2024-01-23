#!/bin/bash

file_to_zip="index.py"
zip_file="self-signed-certificate-lambda.zip"

cd files/self-signed-certificate-lambda || exit

# create zip in specified path
zip "../$zip_file" "$file_to_zip"

cd ..

# if hash changed, then zip changed too
if [[ $(git status --porcelain "$zip_file") ]]; then
    # add and commit changes
    git add $zip_file
    echo "Updated self-signed-certificate-lambda files"
else
    # No changes
    echo "No changes have been made to self-signed-certificate-lambda files"
fi

exit 0
