#!/bin/bash
# generate_docs.sh - Convert Markdown files in specific folders to Word .docx using Pandoc
# Resolves relative folders relative to the script's own location without using realpath

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Hard-coded list of folders relative to script location (relative paths like ../ are fine)
FOLDERS=(
    "../Product Requirements Document/"
)

# Check if pandoc is installed
if ! command -v pandoc &>/dev/null; then
    echo "❌ Error: pandoc is not installed. Please install it and try again."
    exit 1
fi

# Loop through each folder in the list
for folder in "${FOLDERS[@]}"; do
    # If the folder path is absolute, use it as-is, otherwise join it to the script's directory
    if [[ "$folder" = /* ]]; then
        abs_folder="$folder"
    else
        abs_folder="$SCRIPT_DIR/$folder"
    fi

    if [ -d "$abs_folder" ]; then
        echo "📂 Searching in: $abs_folder"
        # Find markdown files (non-recursive; remove -maxdepth 1 for recursion)
        find "$abs_folder" -maxdepth 1 -type f -name "*.md" | while read -r mdfile; do
            base="${mdfile%.*}"
            echo "   ➜ Converting: $mdfile → ${base}.docx"
            pandoc "$mdfile" -o "${base}.docx"
        done
    else
        echo "⚠️  Warning: Folder not found — $folder"
    fi
done

echo "✅ All conversions complete."

