import 'dart:core';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

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

double distanceInMeterByHaversine(LatLng l1, LatLng l2) {
  double x1 = l1.latitude;
  double y1 = l1.longitude;
  double x2 = l2.latitude;
  double y2 = l2.longitude;

  double distance;
  double radius = 6371; // 지구 반지름(km)
  double toRadian = pi / 180;

  double deltaLatitude = (x1 - x2).abs() * toRadian;
  double deltaLongitude = (y1 - y2).abs() * toRadian;

  double sinDeltaLat = sin(deltaLatitude / 2);
  double sinDeltaLng = sin(deltaLongitude / 2);
  double squareRoot = sqrt(
      sinDeltaLat * sinDeltaLat +
          cos(x1 * toRadian) * cos(x2 * toRadian) * sinDeltaLng * sinDeltaLng);

  distance = 2 * radius * asin(squareRoot);

  return distance * 1000;
}
