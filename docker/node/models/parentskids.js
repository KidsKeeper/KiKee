let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let parentskidsSchema = new Schema({
    parentsId: Number,
    kidsId: Number,
    name: String,
}, { collection: 'parentskids', versionKey: false });

module.exports = mongoose.model( 'parentskids', parentskidsSchema );