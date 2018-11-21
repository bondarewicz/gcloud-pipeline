var express = require('express');
var version = require('./package.json').version;

var DEFAULT_PORT = 8080;
var PORT = process.env.PORT || DEFAULT_PORT;
var app = express();

app.get('/', function(req, res) {
  res.send(`gcloud-pipeline xyz-123 v.${version}`);
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);