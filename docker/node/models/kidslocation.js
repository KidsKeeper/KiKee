let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let kidslocationSchema = new Schema({
    parentsId: Number,
    kidsId: Number,
    lon: Number,
    lat: Number,
    start: Array,
    end: Array,
    polygon: Array,
    status: Boolean,
    date: {type: Date, default: Date.now}
}, { collection: 'kidslocation', versionKey: false });

module.exports = mongoose.model( 'kidslocation', kidslocationSchema );