#!/bin/bash
#
######################################################
# GeoPicAll - Image geocoder
# Copyright (c) [2023] [Rylan Shearn]
# Licensed under the MIT License
# Please use and modify at your leisure
######################################################
#
# This script helps to geocode a large number of images that 
# are organised into subfolders making use of geopica.sh and
# geopic.sh to find average coordinates and apply them to 
# non-geocoded images. 
# 
# If you're using this you should be following the following
# workflow, otherwise consider using geopica.sh and geopic.sh
# on their own.
#
# Workflow:
# 1. Organise your pictures (both geocoded and non-geocoded) 
#    into folders that represent rough locations (for example 
#    "New York", "London", "Paris")
# 2. Run this script `geopicall.sh` on the parent folder 
#    that holds all subdirectories. This will run a simple
#    for-loop for `geopica.sh` going through each folder to find 
#    average location, then it will run another for-loop 
#    for `geopic.sh` to write those coordinates to images that 
#    aren't geocoded.
#
# WARNING: This will mofify image metadata. Please understand what it 
#          will do and backup before testing.
#
# Dependencies: exiftool
#               geopica.sh (should be added to PATH)
#               geopic.sh (should be added to PATH)
#
# Usage:
#   ./geopicall.sh <directory>
#
# Options:
#    --help        Display this help and exit


# Display help if --help option is provided
if [[ "$1" == "--help" ]]; then
    head -n 40 "$0" | tail -38
    exit 0
fi


# Check if the argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <parent_folder>"
    exit 1
fi

parent_folder="$1"

# Check if the parent folder exists
if [ ! -d "$parent_folder" ]; then
    echo "Parent folder does not exist: $parent_folder"
    exit 1
fi

# Run geopica.sh on all folders
for dir in "$parent_folder"/*/; do
    if [ -d "$dir" ]; then
        geopica.sh "$dir" --output
    fi
done

# Run geopic.sh on all folders
for dir in "$parent_folder"/*/; do
    if [ -d "$dir" ]; then
        geopic.sh "$dir"
    fi
done

