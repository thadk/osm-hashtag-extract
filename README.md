See comments in Makefile for required apt-get and pip packages (tested on macOS)

Given the proper versions of the python bits, `npm install` inside `csv-bbox-centroid` and all the mentioned binaries installed, most everything will generate with these two commands:

`make data/csv/peacecorps-osm.csv`

and

`make data/json/hotosm-featureCollection-Peace.json`

The first one is only tested so far through:
`make data/sqlite/changesets.sqlite`
