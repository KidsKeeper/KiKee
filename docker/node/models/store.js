let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let storeSchema = new Schema({
    bizesNm: String, // 상호명
    indsLclsCd: String, //상권업종대분류코드
    indsLclsNm: String, // 상권업종대분류명
    indsMclsCd: String, // 상권업종중분류코드
    indsMclsNm: String, // 상권업종중분휴명
    indsSclsCd: String, // 상권업종소분류코드
    indsSclsNm: String, // 상권업종소분류먕
    ctprvnCd: String, // 시도코드
    ctprvnNm: String, // 시도명
    signguCd: String, // 시군구코드
    signguNm: String, // 시군구명
    adongCd: String, // 행정동코드
    adongNm: String, // 행정동명
    ldongCd: String, // 법정동코드
    ldongNm: String, // 법정동명
    lnoAdr: String, // 지번주소
    rdnm: String, // 도로명
    rdnmAdr: String, // 도로명주소
    lon: Number, // 경도
    lat: Number // 위도
}, { collection: 'store' });

module.exports = mongoose.model( 'store', storeSchema );