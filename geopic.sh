#!/bin/bash
#
######################################################
# GeoPic - Apply GPS coordinates to images from an input file
# Copyright (c) [2023] [Rylan Shearn]
# Licensed under the MIT License
# Please use and modify at your leisure
######################################################
#
# This script takes GPS coordinates (latitude and longitude) from
# an input file "average_coordinates.txt" in the specified directory,
# then writes those coordinates to any images in the directory that
# have missing GPS data. This is designed to work in tandem with
# geopica.sh which calculates the average of all GPS coordinates from
# images in the directory and will output to the text file ready for
# this script.
#
# WARNING: This will mofify image metadata. Please understand what it 
#          will do and backup before testing.
#
# Dependencies: exiftool
#
# Usage:
#   ./geopic.sh <directory>
#
# Options:
#    --help        Display this help and exit

# Display help if --help option is provided
if [[ "$1" == "--help" ]]; then
    head -n 28 "$0" | tail -26
    exit 0
fi

# Function to read latitude and longitude from average_coordinates.txt
function read_coordinates {
    local coordinates_file="$1"
    local latitude=""
    local longitude=""

    while IFS=": " read -r key value; do
        if [[ "$key" == "Latitude" ]]; then
            latitude="$value"
        elif [[ "$key" == "Longitude" ]]; then
            longitude="$value"
        fi
    done < "$coordinates_file"

    echo "$latitude $longitude"
}

# Check if the correct number of arguments is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

input_folder="$1"
coordinates_file="${input_folder}/average_coordinates.txt"

# Check if the average_coordinates.txt file exists
if [[ ! -f "$coordinates_file" ]]; then
    echo "Error: average_coordinates.txt not found in the specified folder."
    exit 1
fi

# Read latitude and longitude from average_coordinates.txt
coordinates=$(read_coordinates "$coordinates_file")

# Extract latitude and longitude values
latitude=$(echo "$coordinates" | awk '{print $1}')
longitude=$(echo "$coordinates" | awk '{print $2}')

# Set latitude reference (North/South) based on the sign of the latitude value
if (( $(bc <<< "$latitude >= 0") )); then
    GPSLatitudeRef="North"
else
    GPSLatitudeRef="South"
fi

# Set longitude reference (East/West) based on the sign of the longitude value
if (( $(bc <<< "$longitude >= 0") )); then
    GPSLongitudeRef="East"
else
    GPSLongitudeRef="West"
fi

# Execute exiftool command
exiftool -r -overwrite_original -if "not \$GPSLatitude and not \$GPSLongitude" -GPSLatitude="$latitude" -GPSLongitude="$longitude" -GPSLatitudeRef="$GPSLatitudeRef" -GPSLongitudeRef="$GPSLongitudeRef" "$input_folder"

