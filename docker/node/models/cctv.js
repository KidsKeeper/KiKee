let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let cctvSchema = new Schema({
    lon: String, // 경도
    lat: String // 위도
}, { collection: 'cctv' });

module.exports = mongoose.model( 'cctv', cctvSchema );