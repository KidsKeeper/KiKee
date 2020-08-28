import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class Pair<E, F> {
  final E first;
  final F last;

  Pair(this.first, this.last);

  @override
  int get hashCode => first.hashCode ^ last.hashCode;

  @override
  bool operator ==(other) {
    if (other is! Pair) {
      return false;
    }
    return other.first == first && other.last == last;
  }

  @override
  String toString() => '($first, $last)';

  /// 좌표를 받아와 소숫점 i번째 자리 까지 잘라서 return한다. (기본값 7)
  ///
  /// double 저장시 발생하는 오차를 보정하기 위해 사용.
  static Pair<double, double> geometryFloor(LatLng data, [int i = 7]) {
    String str1 = data.latitude.toString();
    String str2 = data.longitude.toString();

    try {
      str1 = str1.substring(0, str1.indexOf('.') + i);
    } on RangeError {}

    try {
      str2 = str2.substring(0, str2.indexOf('.') + i);
    } on RangeError {}

    return Pair<double, double>(double.parse(str1), double.parse(str2));
  }
}

class Tuple3<E, F, G> {
  final E one;
  final F two;
  final G three;

  Tuple3(this.one, this.two, this.three);

  @override
  int get hashCode => one.hashCode ^ two.hashCode ^ three.hashCode;

  @override
  bool operator ==(other) {
    if (other is! Tuple3) {
      return false;
    }
    return other.one == one && other.two == two && other.three == three;
  }

  @override
  String toString() => '($one, $two, $three)';

}
/// 하버사인 공식,
///
/// 두 좌표 사이의 거리를 계산해서 m로 반환.
double distanceInMeterByHaversine(LatLng l1, LatLng l2) {
  if(l1 == null || l2 == null)
    return 9999;
    
  double distance;

  final double radius = 6371; // 지구 반지름(km)
  final double toRadian = pi / 180;
  double x1 = l1.latitude;
  double y1 = l1.longitude;
  double x2 = l2.latitude;
  double y2 = l2.longitude;

  double deltaLatitude = (x1 - x2).abs() * toRadian;
  double deltaLongitude = (y1 - y2).abs() * toRadian;

  double sinDeltaLat = sin(deltaLatitude / 2);
  double sinDeltaLng = sin(deltaLongitude / 2);
  double squareRoot = sqrt(sinDeltaLat * sinDeltaLat +
      cos(x1 * toRadian) * cos(x2 * toRadian) * sinDeltaLng * sinDeltaLng);

  distance = 2 * radius * asin(squareRoot);

  return distance * 1000;
}

Future<BitmapDescriptor> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  Uint8List result = (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  return BitmapDescriptor.fromBytes(result);
}
