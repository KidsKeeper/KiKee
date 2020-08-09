let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let kidslocationSchema = new Schema({
    parentsId: Number,
    kidsId: Number,
    lon: Number,
    lat: Number,
    start: Number,
    end: Number,
    polygon: Array,
    status: Boolean
}, { collection: 'kidslocation', versionKey: false });

module.exports = mongoose.model( 'kidslocation', kidslocationSchema );