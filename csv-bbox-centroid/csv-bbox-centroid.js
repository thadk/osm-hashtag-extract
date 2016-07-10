var fs = require('fs'),
  csv = require('csv-parser');
  var turfBboxPolygon = require('turf-bbox-polygon');
  var geojsonArea = require('geojson-area');
  var csvWriter = require('csv-write-stream');
  var argv = require('minimist')(process.argv.slice(2));

if (argv._ && argv._.length < 2) {
  console.log("takes csv with \nno input output file arguments.\n\tnode csv-bbox-centroid.js in.csv out.csv")
  return
}

var writer = csvWriter();
writer.pipe(fs.createWriteStream(argv._[2]));

fs.createReadStream(argv._[2])
  .pipe(csv())
  .on('data', function(data) {

    var rectangleCentroid = function (rectangle) {
      var bbox = rectangle.coordinates;
      var xmin = bbox[0][0],
        ymin = bbox[0][1],
        xmax = bbox[1][0],
        ymax = bbox[1][1];
      var xwidth = xmax - xmin;
      var ywidth = ymax - ymin;
      return {
        'type': 'Point',
        'coordinates': [xmin + xwidth / 2, ymin + ywidth / 2]
      };
    };

    /* nonstandard format */
    var rectangle = {
      coordinates: [
        [parseFloat(data.min_lon), parseFloat(data.min_lat)],
        [parseFloat(data.max_lon), parseFloat(data.max_lat)]
      ]
    };

    /* standard format */
    var bbox = [parseFloat(data.min_lon), parseFloat(data.min_lat), parseFloat(data.max_lon), parseFloat(data.max_lat)];
    var rectPoly = turfBboxPolygon(bbox);

    var out = rectangleCentroid(rectangle);
    var area = geojsonArea.geometry(rectPoly.geometry);

    writer.write({
      rowid: data.rowid,
      user_id: data.user_id,
      msg: data.msg,
      closed_at: data.closed_at,
      num_changes: data.num_changes,
      longitude: out.coordinates[0],
      latitude: out.coordinates[1],
      poly: JSON.stringify(rectPoly),
      area: area
    });
  });
