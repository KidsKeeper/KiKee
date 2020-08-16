import 'package:flutter/material.dart';

List<Color> red = [Color(0xFFFFA590), Color(0xFFFF876B),Color(0xFFFF4B21)];
List<Color> orange = [Colors.orange[50], Colors.orange, Colors.orange[900]];
List<Color> yellow = [Color(0xfffef8be), Color(0xFFFFBF20), Colors.yellow[900]];
List<Color> blue = [Color(0xffdffbff),Color(0xff00c4ff), Color(0xff0088ff)];
List<List<Color>> colors = [red, orange, yellow, blue];

Widget routeSelectionCard(RouteSelectionClass rs) {
  return Card(
    color: colors[rs.colorId][0],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25,
            child: Icon(
              Icons.directions_walk,
              color: Colors.white,
              size: 40,
            ),
            backgroundColor: colors[rs.colorId][1],
          ),
        ),
        Text(
          rs.distance.length>=4?calculateDistance(rs.distance):'${rs.distance}m',
          style: TextStyle(
              color: colors[rs.colorId][1],
              fontSize: 20,
              fontFamily: 'BMJUA',
              textBaseline: TextBaseline.alphabetic),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${rs.time}분',
            style: TextStyle(
                color: colors[rs.colorId][2],
                fontSize: 40,
                fontFamily: 'BMJUA'),
          ),
        ),
      ],
    ),
  );
}

class RouteSelectionClass implements Comparable<RouteSelectionClass> {
  String distance;
  String time;
  int colorId;
  dynamic polylineId;
  int danger;
  RouteSelectionClass(
      {this.distance, this.colorId, this.time, this.polylineId, this.danger});
  @override
  int compareTo(RouteSelectionClass other) {
    int result = danger - other.danger;
    if (result == 0)
      return int.parse(distance) - int.parse(other.distance);
    return danger - other.danger;
  }
}

String calculateDistance(String distance)
{
  int len = distance.length;
  String km = distance.substring(0,len-3);
  String m = distance.substring(len-3);
  return km+"."+m+"km";
}