See comments in Makefile for required `apt-get`/`brew`, `npm` and `pip` packages (tested on macOS)

In order to get the submodules, be sure to clone with:
`git clone --recursive https://github.com/thadk/osm-hashtag-extract`

Given the proper versions of the python bits, `npm install` inside `csv-bbox-centroid` and all the mentioned binaries installed, most everything will generate with these two commands:

`make data/csv/peacecorps-osm.csv`

and

`make data/json/hotosm-featureCollection-Peace.json` (example)

The first one is only tested so far through:
`make data/sqlite/changesets.sqlite`


See Also
-------

* https://github.com/osmlab/osm-meta-util
* https://www.developmentseed.org/blog/2015/02/19/tapping-into-osm-metadata/
