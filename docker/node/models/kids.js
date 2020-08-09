let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let kidsSchema = new Schema({
    kidsId: Number,
    key: String,
    try: Number
}, { collection: 'kids', versionKey: false });

module.exports = mongoose.model( 'kids', kidsSchema );