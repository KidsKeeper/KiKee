let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let parentsSchema = new Schema({
    parentsId: Number,
    key: String,
}, { collection: 'parents', versionKey: false });

module.exports = mongoose.model( 'parents', parentsSchema );