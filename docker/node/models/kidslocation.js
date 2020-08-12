let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let kidslocationSchema = new Schema({
    parentsId: Number,
    kidsId: Number,
    lon: Number,
    lat: Number,
    source: String,
    destination: String,
    start: Array,
    end: Array,
    polygon: Array,
    status: Boolean,
    date: String
}, { collection: 'kidslocation', versionKey: false });

module.exports = mongoose.model( 'kidslocation', kidslocationSchema );