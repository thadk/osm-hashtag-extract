A Makefile flow to generate geojson and CSV extracts of the [OpenStreetMap](https://openstreetmap.org) planet changes by Hashtag and also to download the Humanitarian OpenStreetMap Team's (HOT) disaster and other [OSM-Tasks](https://tasks.hotosm.org)  by a user specified hashtag.

This project complements http://osm-analytics.org

##Installing##

In order to get the submodules, be sure to clone with:
`git clone --recursive https://github.com/thadk/osm-hashtag-extract`
 If you forgot, run `git submodule update --init --recursive`.
 
See comments in Makefile for required `apt-get`/`brew`, `npm` and `pip` packages (tested on macOS). `make install-mac` is tested on macOS.

##Usage##

Given the proper versions of the python bits, `npm install` inside `csv-bbox-centroid` and all the mentioned binaries installed, most everything will generate with these two commands:

`make data/csv/peacecorps-osm.csv`

![image](https://media.giphy.com/media/l0HlTRNXTEATghoBi/giphy.gif) 

***Centroids of #PeaceCorps Changesets bounding boxes, updated Sept2016: data viz with Carto***


*Process*: Downloads/extracts 4gb compressed/15gb uncompressed OSM changesets file, converts it to a SQLite database, queries the database for your hashtag, writes out as a bounding-box CSV and then takes the bounding-box CSV and finally uses a small NodeJS script to convert it into a long/lat point CSV.

and

`make data/json/hotosm-featureCollection-Peace.json` (example)

![image](https://cloud.githubusercontent.com/assets/283343/20336383/9c3b0b2e-ab97-11e6-9e4b-82e47cfdc4b2.png) 

***basic data viz with QGIS, tasks through Jul2016***

*Process*: Downloads the 2000-or-so public polygon GeoJSON files from the HOT OSM Task Manager one-by-one, converts it to a feature collection, filters to any particular hashtag/title query, and simplifies the final feature collection for viewing on Github (e.g. https://github.com/thadk/osm-hashtag-extract/blob/master/data/json/hotosm-featureCollection-Peace-ghsize.json ).

and

`make data/csv/hashtag-YourOwnHashtagHere-osm-bbox.csv`

*Process*: Downloads/extracts 4gb compressed/15gb uncompressed OSM changesets file, converts it to a SQLite database, queries the database for your hashtag, writes out as a bounding-box CSV. In order to get points rather than bounding-boxes, you can copy the `data/csv/peacecorps-osm.csv` rule, give it a second new name and replaces the `data/csv/peacecorps-osm-bbox.csv` after the colon with your bounding box CSV filename.

You can add more rules to the Makefile to do your own hashtag queries.

Because we use Make, the script will not try to re-download the files needed to run on each use. If you want to update them to latest versions, simply clean out the original files it downloaded from the `data/` folder. 

See Also
-------

* https://github.com/osmlab/osm-meta-util
* https://www.developmentseed.org/blog/2015/02/19/tapping-into-osm-metadata/
