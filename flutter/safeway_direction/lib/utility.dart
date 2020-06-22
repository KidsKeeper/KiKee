import 'dart:core';
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
    return other.first == first || other.last == last;
  }

  @override
  String toString() => '($first, $last)';

}


Pair<double,double> geometryFloor(LatLng data, [int i = 7]){
  String str1 = data.latitude.toString();
  String str2 = data.longitude.toString();
  
  str1 = str1.substring(0, str1.indexOf('.')+i);
  str2 = str2.substring(0, str2.indexOf('.')+i);

  return Pair<double,double>(double.parse(str1), double.parse(str1));

}