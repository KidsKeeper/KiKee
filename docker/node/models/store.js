let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let storeSchema = new Schema({
    bizesId: String,
    bizesNm: String, // 상호명
    brchNm: String,
    indsLclsCd: String, //상권업종대분류코드
    indsLclsNm: String, // 상권업종대분류명
    indsMclsCd: String, // 상권업종중분류코드
    indsMclsNm: String, // 상권업종중분휴명
    indsSclsCd: String, // 상권업종소분류코드
    indsSclsNm: String, // 상권업종소분류먕
    ksicCd: String,
    ksicNm: String,
    ctprvnCd: String, // 시도코드
    ctprvnNm: String, // 시도명
    signguCd: String, // 시군구코드
    signguNm: String, // 시군구명
    adongCd: String, // 행정동코드
    adongNm: String, // 행정동명
    ldongCd: String, // 법정동코드
    ldongNm: String, // 법정동명
    lnoCd: String,
    plotSctCd: String,
    plotSctNm: String,
    lnoMnno: Number,
    lnoSlno: Number,
    lnoAdr: String, // 지번주소
    rdnmCd: String,
    rdnm: String, // 도로명
    bldMnno: Number,
    bldSlno: String,
    bldMngNo: String,
    bldNm: String,
    rdnmAdr: String, // 도로명주소
    oldZipcd: String,
    newZipcd: String,
    dongNo: String,
    flrNo: String,
    hoNo: String,
    lon: Number, // 경도
    lat: Number // 위도
}, { collection: 'store' });

module.exports = mongoose.model( 'store', storeSchema );