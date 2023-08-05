# GeoPicA - Image Average GPS Coordinates Calculator

GeoPicA is a bash script that calculates the average GPS coordinates (latitude and longitude) for all JPEG images in a specified directory that contain valid GPS coordinates. It uses the `exiftool` command-line tool to read the GPS coordinates from the image metadata.

## Usage

```
bash
./geopica.sh [options] <directory>
```

## Options
`--help:` Display the help and usage instructions.
`--output:` Write the average GPS coordinates to a file named 'average_coordinates.txt' in the specified directory.

## Dependencies
GeoPicA requires the exiftool command-line tool to read the image metadata. Install it before running the script.

## Contributions
Contributions to GeoPicA are welcome! If you find a bug, have a feature request, or want to contribute improvements, feel free to open an issue or submit a pull request.

## License
GeoPicA is licensed under the MIT License.

