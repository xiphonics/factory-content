#!/bin/bash

# Exit on error
set -e

# Function to copy samples and truncate filenames if they are too long
copy_and_truncate_samples() {
  local source_dir=$1
  local dest_dir=$2
  local max_len=24

  echo "Copying samples from $source_dir to $dest_dir, truncating long filenames..."

  # Create all directories first
  find "$source_dir" -type d -print0 | while IFS= read -r -d '' dirpath; do
    relative_path="${dirpath#$source_dir}"
    mkdir -p "$dest_dir$relative_path"
  done

  # Now copy files
  find "$source_dir" -type f -print0 | while IFS= read -r -d '' filepath; do
    relative_path="${filepath#$source_dir}"
    dir=$(dirname "$relative_path")
    filename=$(basename "$relative_path")

    new_filename="$filename"
    if [ ${#filename} -gt $max_len ]; then
      name="${filename%.*}"
      extension="${filename##*.}"
      if [ "$name" = "$filename" ] || [ -z "$extension" ]; then # no extension
          new_filename="${filename:0:$max_len}"
      else
          ext_len=$(( ${#extension} + 1 )) # with dot
          if [ $ext_len -ge $max_len ]; then
              new_filename="${filename:0:$max_len}"
          else
              name_len=$(( max_len - ext_len ))
              new_filename="${name:0:$name_len}.${extension}"
          fi
      fi
    fi
    
    cp "$filepath" "$dest_dir$dir/$new_filename"
  done
}

# Create pico-sd.zip
echo "Creating pico-sd.zip..."
mkdir -p pico-temp/projects
cp -r themes pico-temp/
copy_and_truncate_samples "samples" "pico-temp/samples"
cp -r instruments pico-temp/
# Check if projects/pico exists and has content
if [ -d "projects/pico" ] && [ -n "$(ls -A projects/pico)" ]; then
    cp -r projects/pico/* pico-temp/projects/
fi
(cd pico-temp && zip -r ../pico-sd.zip .)
rm -rf pico-temp
echo "pico-sd.zip created."

# Create advance-sd.zip
echo "Creating advance-sd.zip..."
mkdir -p advance-temp/projects
cp -r themes advance-temp/
copy_and_truncate_samples "samples" "advance-temp/samples"
cp -r instruments advance-temp/
# Check if projects/advance exists and has content
if [ -d "projects/advance" ] && [ -n "$(ls -A projects/advance)" ]; then
    cp -r projects/advance/* advance-temp/projects/
fi
(cd advance-temp && zip -r ../advance-sd.zip .)
rm -rf advance-temp
echo "advance-sd.zip created."

echo "Done."
