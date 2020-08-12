import 'package:flutter/material.dart';

List<Color> red = [Colors.red[50], Colors.red, Colors.red[900]];
List<Color> orange = [Colors.orange[50], Colors.orange, Colors.orange[900]];
List<Color> yellow = [Colors.yellow[50], Colors.yellow, Colors.yellow[900]];
List<Color> blue = [Colors.blue[50], Colors.blue, Colors.blue[900]];
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
            radius: 20,
            child: Icon(
              Icons.directions_walk,
              color: Colors.white,
            ),
            backgroundColor: colors[rs.colorId][1],
          ),
        ),
        Text(
          '${rs.distance}m',
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
