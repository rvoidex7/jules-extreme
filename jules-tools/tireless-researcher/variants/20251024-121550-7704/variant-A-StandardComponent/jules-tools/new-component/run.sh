#!/bin/bash

# --- New Component Scaffolder Tool ---
# This script automates the creation of new code units (components, pages, etc.)
# based on predefined templates.

# --- Default Values ---
COMPONENT_TYPE=""
COMPONENT_NAME=""

# --- Helper function for usage message ---
usage() {
    echo "Usage: $0 --type <type> --name <ComponentName>"
    echo ""
    echo "Arguments:"
    echo "  --type    Required. The type of the code unit to create (e.g., react-component)."
    echo "  --name    Required. The name of the component (e.g., Button)."
    exit 1
}

# --- Parse Command-Line Arguments ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --type) COMPONENT_TYPE="$2"; shift ;;
        --name) COMPONENT_NAME="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# --- Validate Required Arguments ---
if [ -z "$COMPONENT_TYPE" ] || [ -z "$COMPONENT_NAME" ]; then
    echo "Error: Missing required arguments."
    usage
fi

# --- Main Logic (Skeleton) ---
echo "⚙️  '$COMPONENT_NAME' adında bir '$COMPONENT_TYPE' oluşturuluyor..."
echo "--------------------------------------------------"

# TODO: Add the core scaffolding logic here.
# 1. Define the source template directory based on COMPONENT_TYPE.
#    TEMPLATE_DIR="templates/$COMPONENT_TYPE"
#
# 2. Check if the template directory exists.
#    if [ ! -d "$TEMPLATE_DIR" ]; then
#        echo "Error: Template type '$COMPONENT_TYPE' not found."
#        exit 1
#    fi
#
# 3. Define the destination directory.
#    DEST_DIR="src/components/$COMPONENT_NAME"
#    mkdir -p "$DEST_DIR"
#
# 4. Loop through template files, replace placeholders, and copy to destination.
#    for file in $(find "$TEMPLATE_DIR" -name "*.template"); do
#        # Read content, replace {{ComponentName}} with COMPONENT_NAME
#        # Create new file in DEST_DIR
#    done

echo "✅ '$COMPONENT_NAME' bileşeni başarıyla oluşturuldu (simülasyon)."
echo "Bu betik şu anda bir iskelettir ve gerçek dosya oluşturma mantığı henüz eklenmemiştir."
