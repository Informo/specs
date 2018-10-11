#!/bin/sh

set -e

for FILE in static/images/*.src.svg; do
	inkscape "$FILE" --export-text-to-path --export-plain-svg="$(dirname $FILE)/$(basename $FILE .src.svg).svg"
	echo "Converted $FILE"
done
