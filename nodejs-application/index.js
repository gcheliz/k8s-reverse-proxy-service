var express = require('express')
var app = express()

app.get('/hello', function (req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.json({"hello":"world"});
})

app.listen(8080, function () {
  console.log('app listening on port 8080!')
})
