let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let kidspolygonSchema = new Schema({
    parentsId: Number,
    kidsId: Number,
    source: String,
    destination: String,
    start: Array,
    end: Array,
    polygon: Array,
    date: String
}, { collection: 'kidspolygon', versionKey: false });

module.exports = mongoose.model( 'kidspolygon', kidspolygonSchema );