#!/bin/bash

# Set the working directory
cd /home/dockeruser/Real-ESRGAN

# Iterate over files in the input directory
input_dir="/home/dockeruser/sync/input"
output_dir="/home/dockeruser/sync/output"

for file in "$input_dir"/*; do
  if [ -f "$file" ]; then
    python inference_realesrgan.py -n RealESRGAN_x4plus -i "$file" -o "$output_dir"
  fi
done