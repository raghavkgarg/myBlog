#!/bin/bash

# Exit immediately if any command fails
set -e

# Check if slug parameter is provided
if [ -z "$1" ]; then
    echo "Error: Please provide the post slug as a parameter."
    echo "Usage: ./generate_audio.sh <post_slug>"
    echo "Example: ./generate_audio.sh rbi-fsr-june2026"
    exit 1
fi

SLUG="$1"
WORKSPACE_DIR="/Users/raghavgarg/Projects/myBlog/Sanvasify"
MD_FILE="${WORKSPACE_DIR}/content/posts/${SLUG}.md"
TEMP_TXT="/Users/raghavgarg/NotOnCloud/${SLUG}.txt"
TEMP_M4A="/Users/raghavgarg/NotOnCloud/temp_${SLUG}.m4a"
OUTPUT_MP3="${WORKSPACE_DIR}/assets/audio/${SLUG}.mp3"

# Verify that the markdown file exists
if [ ! -f "$MD_FILE" ]; then
    echo "Error: Markdown file not found at ${MD_FILE}"
    exit 1
fi

echo "Cleaning markdown content..."
export MD_FILE TEMP_TXT
python3 << 'EOF'
import os
import re

md_file = os.environ['MD_FILE']
temp_txt = os.environ['TEMP_TXT']

with open(md_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Extract title and description from front matter
title = ''
description = ''
fm_match = re.match(r'^---\s*\n(.*?)\n---', content, flags=re.DOTALL)
if fm_match:
    fm_text = fm_match.group(1)
    title_match = re.search(r'^title:\s*(.*?)\s*$', fm_text, re.MULTILINE)
    if title_match:
        title = title_match.group(1).strip(' \'"“”')
    desc_match = re.search(r'^description:\s*(.*?)\s*$', fm_text, re.MULTILINE)
    if desc_match:
        description = desc_match.group(1).strip(' \'"“”')

# Remove front matter
body = re.sub(r'^---.*?---', '', content, flags=re.DOTALL)

# Clean body line by line
lines = body.splitlines()
cleaned_lines = []
for line in lines:
    stripped = line.strip()
    # Skip shortcodes
    if stripped.startswith('{{<') and stripped.endswith('>}}'):
        continue
    # Skip headers that should not be spoken
    if re.match(r'(?i)^#####\s*Listen to', stripped):
        continue
    if stripped == '## How India defending Rupees':
        continue
    cleaned_lines.append(line)

cleaned_body = '\n'.join(cleaned_lines)
# Reduce multiple empty lines to at most two
cleaned_body = re.sub(r'\n{3,}', '\n\n', cleaned_body).strip()

# Combine title, description, and body
final_text = ''
if title:
    final_text += title + '.\n\n'
if description:
    final_text += description + '.\n\n'
final_text += cleaned_body

with open(temp_txt, 'w', encoding='utf-8') as f:
    f.write(final_text)
EOF


echo "Generating speech (M4A)..."
say -f "${TEMP_TXT}" -o "${TEMP_M4A}"

echo "Compressing and converting to MP3..."
# Create assets/audio directory if it does not exist
mkdir -p "$(dirname "${OUTPUT_MP3}")"
ffmpeg -y -i "${TEMP_M4A}" -codec:a libmp3lame -b:a 32k "${OUTPUT_MP3}"

echo "Cleaning up temporary files..."
rm -f "${TEMP_TXT}" "${TEMP_M4A}"

echo "Success! Audio generated at: ${OUTPUT_MP3}"
