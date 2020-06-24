let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let deathSchema = new Schema({
    acc_year: String, // 사고년도
    dth_dnv_cnt: Number, // 사망자수
    injpsn_cnt: Number, // 부상자수
    se_dnv_cnt: Number, // 부상자수
    sl_dnv_cnt: Number, // 중상자수
    wnd_dnv_cnt: Number, // 경상자수
    occrrnc_lc_sgg_cd: String, // 위치 시도코드
    occrrnc_lc_sido_cd: String, // 위치 시군구코드
    lo_crd: String, // 경도
    la_crd: String // 위도
}, { collection: 'death' });

module.exports = mongoose.model( 'death', deathSchema );