#!/bin/bash

# Download Plugins
./Download-Files.ps1 -FileName Plugins.txt

# Download Windows Files
./Download-Files.ps1 -FileName Windows.txt

# Read the openfire version
openfire_version=$(cat openfire_version.txt)

# Check if the current branch already has the tag
if git rev-parse "$openfire_version" >/dev/null 2>&1; then
    echo "Tag $openfire_version already exists on the current branch."
else
    echo "Tag $openfire_version does not exist. Preparing a new branch for this version..."

    # Create a new branch with the openfire version if it doesn't exist
    git checkout -b "openfire-$openfire_version"

    # Check if it's a new version and reset build version if needed
    if [ ! -f buildver.txt ] || [ "$(git rev-list --all --count)" -eq 1 ]; then
        echo "0" > buildver.txt
        echo "Starting build version at 0 for new version."
    fi

    # Read the current build version from buildver.txt
    build_version=$(cat buildver.txt)

    # Increment the build version
    new_build_version=$((build_version + 1))
    echo "$new_build_version" > buildver.txt

    # Tag the branch with the openfire version
    git tag -a "$openfire_version" -m "Running Openfire Version: $openfire_version"

    # Commit changes and add all modified files
    git add .
    git commit -m "Initial commit for Openfire version $openfire_version, build version $new_build_version"

    # Push the branch and the tag to the remote repository
    git push origin "openfire-$openfire_version"
    git push origin "$openfire_version"
fi

# Build and tag the Docker image
docker build \
-t "armyguy255a/openfire:latest" \
-t "armyguy255a/openfire:$openfire_version" \
-t "armyguy255a/openfire:v$new_build_version" .
