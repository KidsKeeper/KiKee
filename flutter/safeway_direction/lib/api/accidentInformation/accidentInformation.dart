import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const _servicekey = "secret";

class AccidentArea{
  String kind	= "";       //  사고종류
  String sido_sgg_nm;     //	시도시군구명
  String spot_nm;         //	지점명
  int occrrnc_cnt;        //	사고건수
  int caslt_cnt;          //	사상자수
  int dth_dnv_cnt;        //	사망자수
  int se_dnv_cnt;         //	중상자수
  int sl_dnv_cnt;         //	경상자수
  List<LatLng> geom_json; //	다발지역폴리곤
  LatLng location;

}

  Future<List<AccidentArea>> getAccidentInformation(LatLng l1, LatLng l2) async{
    http.Response response = await http.get("http://3.34.194.177:8088/$_servicekey/api/frequently?minx=${l1.latitude}&miny=${l1.longitude}&maxx=${l2.latitude}&maxy${l2.longitude}");
    Map responseJson = jsonDecode(response.body);
    
    List<AccidentArea> result = [];

    if(responseJson["error"] == "no data")
      return result;

    
    return result;
  }