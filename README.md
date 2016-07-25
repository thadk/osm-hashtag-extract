See comments in Makefile for required `apt-get`/`brew`, `npm` and `pip` packages (tested on macOS)

In order to get the submodules, be sure to clone with:
`git clone --recursive https://github.com/thadk/osm-hashtag-extract`
 If you forgot, run `git submodule update --init --recursive`.
 


Given the proper versions of the python bits, `npm install` inside `csv-bbox-centroid` and all the mentioned binaries installed, most everything will generate with these two commands:

`make data/csv/peacecorps-osm.csv`

*Process*: Downloads/extracts 4gb compressed/15gb uncompressed OSM changesets file, converts it to a SQLite database, queries the database for your hashtag, writes out as a bounding-box CSV and then takes the bounding-box CSV and finally uses a small NodeJS script to convert it into a long/lat point CSV.

and

`make data/json/hotosm-featureCollection-Peace.json` (example)

*Process*: Downloads the 2000-or-so public polygon GeoJSON files from the HOT OSM Task Manager one-by-one, converts it to a feature collection, filters to any particular hashtag/title query, and simplifies the final feature collection for viewing on Github (e.g. https://github.com/thadk/osm-hashtag-extract/blob/master/data/json/hotosm-featureCollection-Peace-ghsize.json ).

The first one is only tested so far through:
`make data/sqlite/changesets.sqlite`


See Also
-------

* https://github.com/osmlab/osm-meta-util
* https://www.developmentseed.org/blog/2015/02/19/tapping-into-osm-metadata/
