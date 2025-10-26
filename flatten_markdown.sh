#!/bin/bash

set -e
set -u

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <source_directory> <destination_directory>

Flatten nested markdown files into a single directory with path prefixes.

OPTIONS:
    -h, --help           Show this help
    -v, --verbose        Verbose output
    -d, --dry-run        Preview without copying
    -e, --extension EXT  File extension (default: md)

EXAMPLES:
    $(basename "$0") ~/source/docs ~/output
    $(basename "$0") --dry-run ~/source ~/output
    $(basename "$0") --extension txt ~/source ~/output
EOF
}

# Parse arguments
VERBOSE=false
DRY_RUN=false
FILE_EXTENSION="md"
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_help; exit 0 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -d|--dry-run) DRY_RUN=true; shift ;;
        -e|--extension) FILE_EXTENSION="$2"; shift 2 ;;
        *) POSITIONAL_ARGS+=("$1"); shift ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}"

if [ "$#" -ne 2 ]; then
    echo "Error: Need source and destination directories"
    show_help
    exit 1
fi

SOURCE_DIR="${1/#\~/$HOME}"
DEST_DIR="${2/#\~/$HOME}"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist"
    exit 1
fi

[ "$DRY_RUN" = false ] && mkdir -p "$DEST_DIR"

echo "Source: $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo "Extension: .$FILE_EXTENSION"
echo "---"

count=0

while IFS= read -r -d '' file; do
    relative_path="${file#$SOURCE_DIR/}"
    flat_name=$(echo "$relative_path" | tr '/' '_')
    
    if [ "$DRY_RUN" = true ]; then
        echo "Would copy: $relative_path -> $flat_name"
    else
        cp "$file" "$DEST_DIR/$flat_name"
        [ "$VERBOSE" = true ] && echo "Copied: $flat_name"
    fi
    ((count++))
done < <(find "$SOURCE_DIR" -type f -name "*.${FILE_EXTENSION}" -print0)

echo "---"
[ "$DRY_RUN" = true ] && echo "Would copy $count files" || echo "✓ Copied $count files"
