# Bash Scripts Toolkit

A collection of useful bash scripts for everyday automation and productivity tasks.

## Available Scripts

### `flatten_markdown.sh`

Recursively finds all markdown files in nested directories and copies them to a single flat directory with path-prefixed names to avoid conflicts.

**Usage:**
```bash
./flatten_markdown.sh [OPTIONS] <source_directory> <destination_directory>
```

**Options:**
- `-h, --help` - Show help message
- `-v, --verbose` - Show detailed output
- `-d, --dry-run` - Preview changes without copying files
- `-e, --extension EXT` - Specify file extension (default: md)

**Examples:**
```bash
# Flatten markdown files
./flatten_markdown.sh ~/docs ~/output

# Preview without executing
./flatten_markdown.sh --dry-run ~/docs ~/output

# Flatten text files instead
./flatten_markdown.sh --extension txt ~/source ~/output
```

**Output:**
Files are renamed with their path as prefix:
- `a2a/intro.md` → `a2a_intro.md`
- `agents/react/index.md` → `agents_react_index.md`

---

## Installation
```bash
git clone https://github.com/Ben-Cliff/bash-scripts-toolkit.git
cd bash-scripts-toolkit
chmod +x *.sh
```

## Usage
```bash
# Make executable (first time only)
chmod +x flatten_markdown.sh

# Run any script
./flatten_markdown.sh --help
```

## Contributing

Add new scripts directly to the root directory. Each script should:
- Include `--help` documentation
- Validate inputs
- Handle errors gracefully
- Follow the naming convention: `script-name.sh`

## License

MIT
