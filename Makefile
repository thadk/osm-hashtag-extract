#Dependencies to install
#pbzip2, replacable with bzip2 with same flags

#Useful tab completion for Make:
# brew install bash-completion
# add to .bash_profile

# sudo apt-get install git bzip2
# sudo apt-get install python3 python3-setuptools sqlite3 pbzip2
# sudo easy_install3 pip
# sudo pip3 install --upgrade python-dateutil

#################
# DOWNLOAD DATA #
#################

data/osm/planet_latest.osm:
	mkdir -p $(dir $@)
	curl http://planet.openstreetmap.org/planet_latest.osm.bz2 | pbzip2 -cd >$@.download
	mv $@.download $@


data/osm/changesets-latest.osm:
	mkdir -p $(dir $@)
	curl http://planet.osm.org/planet/changesets-latest.osm.bz2  | pbzip2 -cd >$@.download
	mv $@.download $@

#hat tip to http://stackoverflow.com/a/12110773/272018
#Create virtual Make jobs for each HOT task to date.
LAST := 1988
NUMBERS := $(shell seq ${LAST} 5)
JOBS :=  $(addprefix data/json/subfiles/,$(addsuffix .json,${NUMBERS}))
all-hot-subfiles: ${JOBS} ; echo "$@ success"
${JOBS}: data/json/subfiles/%.json: ; curl -f http://tasks.hotosm.org/project/$*.json -o $@.download && mv $@.download $@ || touch $@

#################
# RESHAPE DATA  #
#################


## HOT OSM Tasking Manager ##
data/json/hotosm-features.json: all-hot-subfiles
	mkdir -p $(dir $@)
	jq -s -r '. | @json' data/json/subfiles/*.json > $@

data/json/hotosm-featureCollection-all.json: data/json/hotosm-features.json
	mkdir -p $(dir $@)
	turf featurecollection $(dir $@)hot-all.json > $@

#Filter only HOT OSM tasks that have Peace in the title.
#We had to rely on the non-featurecollection because jq got confused by the large FC array.
data/json/hotosm-featureCollection-Peace.json: data/json/hotosm-features.json
	mkdir -p $(dir $@)
	jq -r 'map(select(.properties.name | . and contains("Peace") ))' $< > $(dir $@)hotosm-peace-features.json
	turf featurecollection $(dir $@)hotosm-peace-features.json > $@
	rm $(dir $@)hotosm-peace-features.json

data/json/hotosm-featureCollection-Peace-ghsize.json: data/json/hotosm-featureCollection-Peace.json
	mkdir -p $(dir $@)
	mapshaper -i $< -simplify 90% keep-shapes -o format=topojson $@


## OSM Hashtags ##

data/sqlite/changesets.sqlite: data/osm/changesets-latest.osm
	mkdir -p $(dir $@)
	cat sometimemachine/schema.sql | sqlite3 $(dir $@)changesets.sqlite
	python3 sometimemachine/stm.py $< $@

data/csv/peacecorps-osm-bbox-nocase.csv: data/sqlite/changesets.sqlite
	mkdir -p $(dir $@)
	sqlite3 $< -header -csv \
	'SELECT rowid,* FROM osm_changeset where msg like "%#PeaceCorps%" COLLATE NOCASE' \
	>> $@

data/csv/peacecorps-osm-bbox.csv: data/sqlite/changesets.sqlite
	mkdir -p $(dir $@)
	sqlite3 $< -header -csv \
	'SELECT * FROM osm_changeset where msg like "%#PeaceCorps%"' \
	>> $@

data/csv/peacecorps-osm.csv: data/csv/peacecorps-osm-bbox.csv
	mkdir -p $(dir $@)
	echo 'Remember to run npm install in csv-bbox-centroid for now'
	node csv-bbox-centroid/csv-bbox-centroid.js $< $@


data/csv/peacecorps-osm-nocase.csv: data/csv/peacecorps-osm-bbox-nocase.csv
	mkdir -p $(dir $@)
	echo 'Remember to run npm install in csv-bbox-centroid for now'
	node csv-bbox-centroid/csv-bbox-centroid.js $< $@

#################
# SHORTCUTS     #
#################

#########
# CLEAN #
#########

clean-local:
	rm -rf data/sqlite/
	rm -rf data/json/subfiles/

clean: clean-local
	rm -rf data/osm
