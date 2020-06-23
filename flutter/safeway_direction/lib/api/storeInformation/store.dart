import 'dart:convert';

import 'package:safewaydirection/api/storeInformation/data/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class Store{
  String bizesId = '10868815'; // 상가 업소 번호
  String bizesNm = '땡땡땡다방'; // 상호명
  String brchNm = '대전땡땡병원점';  // 지점명

  String ksicNm = '비알콜 음료점업'; // 표준산업분류명
  String indsLclsNm = '음식'; // 업종대분류명
  String indsMclsNm = '커피점/카페'; // 업종중분류명
  String indsSclsNm = '커피전문점/카페/다방'; // 업종소분류명

  String ksicCd = 'I56220'; // 표준산업분류 코드
  String indsLclsCd = 'Q'; // 업종대분류 코드
  String indsMclsCd = 'Q12'; // 업종중분류 코드
  String indsSclsCd = 'Q12A01'; // 업종소분류 코드
  Location storeLocation = Location(); // 가게 위치

}

Future<List<Store>> findNearStores(int radius, LatLng location) async{

  List<Store> result = List<Store>();
  List<String> codeList = ["N02A04","N02A05","N08A04","Q09A06","Q09A02","Q09A10","D25A11"];
  String servicekey = 'gYgO7z7S7CpD1JuCgz2NZQHZtDXJ56myCwvvnBMdiFultNVEtYtcjNv5nbmBVgbVlqMzJjkZHpKFGXj9kZw7tQ%3D%3D';

  for(String code in codeList)
    result += await getData(radius, location,code, servicekey);

  return result;
}

Future<List<Store>> findNearStoresInRectangle(LatLng location1, LatLng location2) async{

  List<Store> result = List<Store>();
  List<String> codeList = ["N02A04","N02A05","N08A04","Q09A06","Q09A02","Q09A10","D25A11"];
  String servicekey = 'gYgO7z7S7CpD1JuCgz2NZQHZtDXJ56myCwvvnBMdiFultNVEtYtcjNv5nbmBVgbVlqMzJjkZHpKFGXj9kZw7tQ%3D%3D';

  http.Response response;
  for(String code in codeList){
    String indsLclsCd = code.substring(0,1);
    String indsMclsCd = code.substring(0,3);
    String indsSclsCd = code;
    response = await http.get('http://apis.data.go.kr/B553077/api/open/sdsc/storeListInRectangle?numOfRows=1000&minx=${location1.longitude}&miny=${location1.latitude}&maxx=${location2.longitude}&maxy=${location2.latitude}&indsLclsCd=$indsLclsCd&indsMclsCd=$indsMclsCd&indsSclsCd=$indsSclsCd&type=json&ServiceKey=$servicekey');
    result += _storeListParser(response.body);
  }

  return result;
}

Future<List<Store>> getData(int radius, LatLng location,String code,String serviceKey) async{
  http.Response response;
  String indsLclsCd = code.substring(0,1);
  String indsMclsCd = code.substring(0,3);
  String indsSclsCd = code;
  response = await http.get('http://apis.data.go.kr/B553077/api/open/sdsc/storeListInRadius?radius=$radius&cx=${location.longitude}&cy=${location.latitude}&indsLclsCd=$indsLclsCd&indsMclsCd=$indsMclsCd&indsSclsCd=$indsSclsCd&type=json&ServiceKey=$serviceKey');
  return _storeListParser(response.body);
}

List<Store> _storeListParser(String storeList){
  List<Store> result = List<Store>();
  Map<String,dynamic> data = jsonDecode(storeList);
  if(data['header']['resultCode'] != '00')
    return result;

  List<dynamic> items = data['body']['items'];
  items.forEach((item){
    Store storeData = Store();
    storeData.bizesId = item['bizesId'];
    storeData.bizesNm = item['bizesNm'];
    storeData.brchNm = item['brchNm'];
    storeData.indsLclsCd = item['indsLclsCd'];
    storeData.indsLclsNm = item['indsLclsNm'];
    storeData.indsMclsCd = item['indsMclsCd'];
    storeData.indsMclsNm = item['indsMclsNm'];
    storeData.indsSclsCd = item['indsSclsCd'];
    storeData.indsSclsNm = item['indsSclsNm'];
    storeData.ksicCd = item['ksicCd'];
    storeData.ksicNm = item['ksicNm'];
    storeData.storeLocation.ctprvnCd = item['ctprvnCd'];
    storeData.storeLocation.ctprvnNm = item['ctprvnNm'];
    storeData.storeLocation.signguCd = item['signguCd'];
    storeData.storeLocation.signguNm = item['signguNm'];
    storeData.storeLocation.adongCd = item['adongCd'];
    storeData.storeLocation.adongNm = item['adongNm'];
    storeData.storeLocation.ldongCd = item['ldongCd'];
    storeData.storeLocation.ldongNm = item['ldongNm'];
    storeData.storeLocation.lnoCd = item['lnoCd'];
    storeData.storeLocation.plotSctCd = item['plotSctCd'];
    storeData.storeLocation.plotSctNm = item['plotSctNm'];
    storeData.storeLocation.lnoMnno = item['lnoMnno'].toString();
    storeData.storeLocation.lnoSlno = item['lnoSlno'].toString();
    storeData.storeLocation.lnoAdr = item['lnoAdr'];
    storeData.storeLocation.rdnmCd = item['rdnmCd'];
    storeData.storeLocation.rdnm = item['rdnm'];
    storeData.storeLocation.rdnm = storeData.storeLocation.rdnm.substring(storeData.storeLocation.rdnm.lastIndexOf(' ')+1 ,storeData.storeLocation.rdnm.length);
    storeData.storeLocation.bldMnno = item['bldMnno'].toString();
    storeData.storeLocation.bldSlno = item['bldSlno'].toString();
    storeData.storeLocation.bldMngNo = item['bldMngNo'].toString();
    storeData.storeLocation.bldNm = item['bldNm'];
    storeData.storeLocation.rdnmAdr = item['rdnmAdr'];
    storeData.storeLocation.oldZipcd = int.parse(item['oldZipcd']);
    storeData.storeLocation.newZipcd = int.parse(item['newZipcd']);
    storeData.storeLocation.location = LatLng(item['lat'],item['lon']);
    result.add(storeData);
  });
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