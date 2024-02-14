# Path to the JSON file, this file can be changed
JSON_FILE_PATH="/opt/code-server/marketplace.json"

# Check if the JSON file exists
if [ -f "$JSON_FILE_PATH" ]; then
    # Read JSON content from the file, compact it into a single line using jq
    JSON_CONTENT=$(jq -c . "$JSON_FILE_PATH")
    
    # Export the content as an environment variable
    export EXTENSIONS_GALLERY="$JSON_CONTENT"
fi