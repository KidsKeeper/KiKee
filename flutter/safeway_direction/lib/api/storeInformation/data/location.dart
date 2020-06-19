// 변수안에 있는 초기값은 예시입니다.
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location{
  String ctprvnCd = '30';              // 시도 코드
  String ctprvnNm = '대전광역시'; // 시도명
  String signguCd = '30170';          // 시군구코드
  String signguNm = '서구';      // 시군구명
  String adongCd = '301706400';       // 행정동코드
  String adongNm = '둔산2동';    // 행정동명
  String ldongCd = '3017011200';      // 법정동코드
  String ldongNm = '둔산동';     //법정동명
  String lnoCd  = '3017011200113530000'; //PNU 코드
  String plotSctCd = '1';            //대지구분 코드 , 1은 대지 2는 산
  String plotSctNm = '대지';    // 대지,산 구분
  String lnoMnno = '1353';           // 지번본번지
  String lnoSlno = '9';              // 지번부번지 
  String lnoAdr = "대전광역시 서구 ~~"; // 지번주소
  String rdnmCd = '301704298326';    // 도로명 코드
  String rdnm = '둔산로51번길';  // 도로명
  String bldMnno = '66'; // 건물본번지
  String bldSlno = '1';  // 건물부번지 
  String bldMngNo = '3017011200113530000022216'; //건물관리번호
  String bldNm ='임광빌딩'; //건물명
  String rdnmAdr = '대전광역시 서구 둔산로 51번길 66'; // 도로명 주소

  int oldZipcd = 302830; // 구 우편번호
  int newZipcd = 16618;   // 신 우편번호
  LatLng location = LatLng(36.354149, 127.380605);
  
}