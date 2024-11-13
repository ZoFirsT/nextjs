#!/bin/bash

# Get current date and time for commit message
current_datetime=$(date "+%Y-%m-%d %H:%M:%S")

# Check if there are any changes to commit
if [[ -z $(git status --porcelain) ]]; then
    echo "No changes to commit"
    exit 0
fi

# Prompt for branch choice
read -p "Do you want to commit to main branch? (y/n): " branch_choice

if [[ $branch_choice == "n" || $branch_choice == "N" ]]; then
    # Create and checkout new branch
    read -p "Enter new branch name: " branch_name
    git checkout -b $branch_name
    echo "Created and switched to new branch: $branch_name"
fi

# Add all changes
git add .

# Prompt for commit message
read -p "Enter commit message (press Enter to use auto timestamp): " commit_msg

if [[ -z "$commit_msg" ]]; then
    # Use timestamp if no message provided
    git commit -m "Auto commit: $current_datetime"
else
    # Use custom message if provided
    git commit -m "$commit_msg"
fi

# Get current branch name
current_branch=$(git symbolic-ref --short HEAD)

# Push to remote repository
git push origin $current_branch || {
    echo "Push failed. Please pull latest changes and try again"
    exit 1
}

echo "Changes successfully committed and pushed to branch: $current_branch!"
