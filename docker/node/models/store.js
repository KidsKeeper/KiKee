let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let storeSchema = new Schema({
    bizesNm: String, // 상호명
    indsSclsNm: String, // 상권업종소분류먕
    lnoAdr: String, // 지번주소
    rdnmAdr: String, // 도로명주소
    lon: Number, // 경도
    lat: Number // 위도
}, { collection: 'store' });

module.exports = mongoose.model( 'store', storeSchema );