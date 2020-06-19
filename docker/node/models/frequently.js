let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let frequentlySchema = new Schema({
    kind: String, // 사고종류
    sido_sgg_nm: String, // 시도시군구명
    spot_nm: String, // 지점명
    occrrnc_cnt: Number, // 사고 건수
    caslt_cnt: Number, // 사상자수
    dth_dnv_cnt: Number, // 사망자수
    se_dnv_cnt: Number, // 중상자수
    sl_dnv_cnt: Number, // 경상자수
    geom_json: String, // 다발지역폴리곤
    lo_crd: Number, // 경도
    la_crd: Number // 위도
}, { collection: 'frequently' });

module.exports = mongoose.model( 'frequently', frequentlySchema );