import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:safewaydirection/keys.dart';

const _servicekey = Keys.database;

class Store{
  String bizesNm; //'땡땡땡다방'; // 상호명
  String indsSclsNm; // '커피전문점/카페/다방'; // 업종소분류명
  
  String lnoAdr;  //"대전광역시 서구 ~~"; // 지번주소
  String rdnm; //둔산로51번길// 도로명
  String rdnmAdr; // '대전광역시 서구 둔산로 51번길 66'; // 도로명 주소

  LatLng location; // LatLng(36.354149, 127.380605);

  @override
  int get hashCode => bizesNm.hashCode ^ indsSclsNm.hashCode ^ lnoAdr.hashCode ^ rdnm.hashCode ^ rdnmAdr.hashCode ^ location.hashCode;

  @override
  bool operator ==(dynamic other){
    if(other is! Store)
      return false;

    return (bizesNm == other.bizesNm)
          && (indsSclsNm == other.indsSclsNm)
          && (lnoAdr == other.lnoAdr)
          && (rdnm == other.rdnm)
          && (rdnmAdr == other.rdnmAdr)
          && (location == other.location);
  }
  Store();
  Store.fromJson(Map<String,dynamic> data){
    bizesNm = data['bizesNm'];
    indsSclsNm = data['indsSclsNm'];
    lnoAdr = data['lnoAdr'];
    rdnm = data['rdnm'];
    rdnm = rdnm.substring(rdnm.lastIndexOf(' ')+1 ,rdnm.length);
    rdnmAdr = data['rdnmAdr'];
    location = LatLng(data['lat'],data['lon']);
  }
}

Future<List<Store>> findNearStoresInRectangle(LatLng l1, LatLng l2) async{
  List<Store> result = List<Store>();

  http.Response response = await http.get('http://3.34.194.177:8088/$_servicekey/api/store?minx=${l1.latitude}&miny=${l1.longitude}&maxx=${l2.latitude}&maxy=${l2.longitude}');
  Map<String,dynamic> data = jsonDecode(response.body);

  if(data["error"] == "no data")
    return result;
  for(Map<String,dynamic> iter in data["data"])
    result.add(Store.fromJson(iter));
  return result;
}

/*
관광 /여가/오락 => 무도/유흥/가무 => 무도유흥주점- 종합
N 02 A04
관광 /여가/오락 => 무도/유흥/가무 => 한국식 유흥주점
N 02 A05
관광 /여가/오락 => 무도/유흥/가무 => 나이트 클럽
N 02 A02
관광 /여가/오락 => 경마/경륜/성인오락 => 카지노
N 08 A04
숙박 => 모텔/여관/여인숙 => 모텔/여관/여인숙
O 02 A01 (이름으로 추가적인 데이터 검증 필요)
음식 => 유흥주점 => 관광/유흥주점
Q09A06
음식 => 유흥주점 => 룸살롱/단란주점
Q09A10
음식 => 유흥주점 => 빠/카페/스탠드바
Q09A08 ( 추가적인 데이터 검증 필요)
음식 => 유흥주점 => 소주방/포장마차
Q09A02
음식 => 유흥주점 => 호프/맥주
Q09A01( 추가적인 데이터 검증 필요)
소매 => 기타판매업 => 성인용품판매
D 25 A11
*/