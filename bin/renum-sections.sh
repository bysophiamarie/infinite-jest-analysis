#!/bin/sh
perl -pi -e 's/"section": "?([0-9]+|MISSING)"?/"section": "@{[++$c]}"/' IJ.json
