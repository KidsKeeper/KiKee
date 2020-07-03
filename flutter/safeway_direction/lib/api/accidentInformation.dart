import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const _servicekey = "secret";

class AccidentArea{
  String kind;       //  사고종류
  String sidoSggNm;     //	시도시군구명
  String spotNm;         //	지점명
  int occrrncCnt;        //	사고건수
  int casltCnt;          //	사상자수
  int dthDnvCnt;        //	사망자수
  int seDnvCnt;         //	중상자수
  int slDnvCnt;         //	경상자수
  // List<LatLng> geom_json; //	다발지역폴리곤
  LatLng location;

  AccidentArea.fromJson(Map<String,dynamic> data) {
    kind = data["kind"];
    sidoSggNm= data["sido_sgg_nm"];
    spotNm = data["spot_nm"];
    occrrncCnt = data["occrrnc_cnt"];
    casltCnt = data["caslt_cnt"];
    dthDnvCnt = data["dth_dnv_cnt"];
    seDnvCnt = data["se_dnv_cnt"];
    slDnvCnt = data["sl_dnv_cnt"];
    location = LatLng(double.parse(data["la_crd"]), double.parse(data["lo_crd"]));
  }

}

  Future<List<AccidentArea>> getAccidentInformation(LatLng l1, LatLng l2) async{
    http.Response response = await http.get("http://3.34.194.177:8088/$_servicekey/api/frequently?minx=${l1.latitude}&miny=${l1.longitude}&maxx=${l2.latitude}&maxy${l2.longitude}");
    Map responseJson = jsonDecode(response.body);
    
    List<AccidentArea> result = [];
    if(responseJson["error"] == "no data")
      return result;
    for(var iter in responseJson["data"])
      result.add(AccidentArea.fromJson(iter));
    return result;
  }