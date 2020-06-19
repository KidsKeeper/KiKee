let express = require('express');
let app = express();
let bodyParser = require('body-parser');
let mongoose = require('mongoose');

app.use( bodyParser.urlencoded({ extended: true }));
app.use( bodyParser.json() );

mongoose.set( 'useNewUrlParser', true );
mongoose.set( 'useUnifiedTopology', true );
mongoose.connect('mongodb://mongo/kikee');

let db = mongoose.connection;
db.on( 'error', console.error );
db.once('open', function () {
    console.log('db connect');
});

let frequently = require('./models/frequently');
let death = require('./models/death');
// let store = require('/models/store');

let port = process.env.PORT || 8088;
let route = require('./route/index')( app, frequently, death );

let server = app.listen(port, function () {
    console.log('server start');
});