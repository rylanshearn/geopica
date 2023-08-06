# GeoPicA
These are a series of scripts to help with geocoding your image library. It assumes you have some images that are geocoded already, and allows you to apply a rough estimate to those missing coordinates. The workflow could be as follows:

1. Organise your pictures (both geocoded and non-geocoded) into folders that represent rough locations (for example "New York", "London", "Paris")
2. Run `geopica.sh` for each folder to find average location
3. Run `geopic.sh` to write those coordinates to images that aren't geocoded

If you don't plan to modify this workflow, you might consider using `geopicall.sh` which will geocode all subdirectories of a specified parent directory using the steps above.

# WARNING
Please understand these scripts modify image metadata. Please backup and do testing before running this on your actual library. Personally I would always keep the originals without geocoding anyway.

# Installation

- clone repo from github:
```
git clone https://github.com/rylanshearn/geopica
```
- make executable
```
cd geopica/
chmod +x geopic.sh geopica.sh geopicall.sh
```
- add to path (for example `~/bin/`) - this is only necessary for `geopicall.sh` to call the other two scripts
```
cp geopic.sh geopica.sh geopicall.sh ~/your/path/dir/
```

## Script details: GeoPicA

`geopica.sh` is a bash script that calculates the average GPS coordinates (latitude and longitude) for all JPEG images in a specified directory that contain valid GPS coordinates. It uses the [exiftool](https://exiftool.org/ "exiftool") command-line tool to read the GPS coordinates from the image metadata.

This is useful if you have your family pictures organised by location. You can run this script and get an average location for each folder for example. You can then use this average to geocode other images in the folder that have missing data using `geopic.sh` (see below).

### Usage

```
./geopica.sh <directory> [options]
```

### Options
`--help:` Display the help and usage instructions.

`--output:` Write the average GPS coordinates to a file named 'average_coordinates.txt' in the specified directory.

## Script details: GeoPic
`geopic.sh` is a script that takes GPS coordinates (latitude and longitude) from an input file `average_coordinates.txt` in the specified directory, then writes those coordinates to any images in the directory that have missing GPS data using [exiftool](https://exiftool.org/ "exiftool"). This is designed to work in tandem with `geopica.sh` which calculates the average of all GPS coordinates from images in the directory and will output to the text file ready for this script. However, if you have a directory without any geocoded images, you can add the file there manually so long as it's name is `average_coordinates.txt` and it is in this format:

```
Latitude: 47.2
Longitude: 4.9
```

### Usage

```
./geopic.sh <directory>
```

## Script details: GeoPicAll
`geopicall.sh` has two simple for-loops that will go through all subfolders in a specified directory and:
1. Run `geopica.sh` for each folder to find average location
2. Run `geopic.sh` to write those coordinates to images that aren't geocoded

## Dependencies
All scripts require the [exiftool](https://exiftool.org/ "exiftool") command-line tool to read the image metadata. Install it before running. All scripts were tested using exiftool version 12.4 on Ubuntu 22.04.2

These scripts are made for Ubuntu linux and you may need to modify the way exiftool is being used if running this on other platforms.

## Contributions
Contributions to this project are welcome! It would be much nicer in a single script with more arguments but this has been kind of a quick job. If you find a bug, or want to contribute improvements, feel free to open an issue or submit a pull request.

## License
GeoPicA is licensed under the MIT License.

