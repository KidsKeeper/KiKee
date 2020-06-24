const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const router = require('./router/index');

let app = express();

app.use( bodyParser.urlencoded({ extended: true }));
app.use( bodyParser.json() );

app.use(router);

mongoose.set( 'useNewUrlParser', true );
mongoose.set( 'useUnifiedTopology', true );
mongoose.connect('mongodb://mongo/kikee');

let db = mongoose.connection;
db.on( 'error', console.error );
db.once('open', function () {
    console.log('db connect');
});

let port = process.env.PORT || 8088;

let server = app.listen(port, function () {
    console.log('server start');
});