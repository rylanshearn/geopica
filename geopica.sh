#!/bin/bash
#
######################################################
# GeoPicA - Image Average GPS Coordinates Calculator
# Copyright (c) [2023] [Rylan Shearn]
# Licensed under the MIT License
# Please use and modify at your leisure
######################################################
#
# This script calculates the average GPS coordinates (latitude and longitude) for all JPEG 
# images in the specified directory that contain valid GPS coordinates.
#
# Dependencies: exiftool
#
# Usage:
#   ./geopica.sh [options] <directory>
#
# Options:
#    --help        Display this help and exit
#    --output      Write the average GPS coordinates to a file named 'average_coordinates.txt'
#                  in the specified directory

# Display help if --help option is provided
if [[ "$1" == "--help" ]]; then
    sed -n '/^#/,/^$/s/^# \?//p' "$0"
    exit 0
fi

shopt -s nocaseglob  # Enable case-insensitive globbing

# Check if the directory argument is provided
if [[ -z "$1" ]]; then
    echo "Error: Directory argument is missing."
    echo "Usage: ./geopica.sh [options] <directory>"
    exit 1
fi

# Check if all images have GPS coordinates
directory=$1
images_with_gps=()
images_without_gps=()
while IFS= read -r file; do
    if exiftool -if '($GPSLatitude) and ($GPSLongitude)' -n "$file" &>/dev/null; then
        images_with_gps+=("$file")
        echo "GPS coordinates found for $file"
        exiftool -n -gpslatitude -gpslongitude "$file"
    else
        images_without_gps+=("$file")
    fi
done < <(find "$directory" -maxdepth 1 -type f -iname '*.jpg' -o -iname '*.JPG')

if [[ ${#images_with_gps[@]} -eq 0 ]]; then
    echo "No images with GPS coordinates found in the directory: $directory"
    exit 1
fi

# Calculate the average coordinates
if [[ ${#images_with_gps[@]} -gt 1 ]]; then
    sum_latitude=0
    sum_longitude=0

    for file in "${images_with_gps[@]}"; do
        latitude=$(exiftool -n -gpslatitude "$file" | grep -Eo "[0-9.-]+")
        longitude=$(exiftool -n -gpslongitude "$file" | grep -Eo "[0-9.-]+")
        sum_latitude=$(awk "BEGIN {print $sum_latitude + $latitude}")
        sum_longitude=$(awk "BEGIN {print $sum_longitude + $longitude}")
    done

    avg_latitude=$(awk "BEGIN {print $sum_latitude / ${#images_with_gps[@]}}")
    avg_longitude=$(awk "BEGIN {print $sum_longitude / ${#images_with_gps[@]}}")

    
    echo "Average GPS coordinates"
    echo "Latitude: $avg_latitude"
    echo "Longitude: $avg_longitude"
    
    # Write to average_coordinates.txt if out argument given
    if [[ "$2" == "--output" ]]; then
        output_file="$directory/average_coordinates.txt"
        echo "Writing Average GPS coordinates to $output_file"
        echo "Latitude: $avg_latitude" > "$output_file"
        echo "Longitude: $avg_longitude" >> "$output_file"
    fi
else
    echo "Only one image with GPS coordinates found. Cannot calculate average."
fi

exit 0

