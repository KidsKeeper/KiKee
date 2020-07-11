import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Color> Red = [Colors.red[50],Colors.red,Colors.red[900]];
List<Color> Orange = [Colors.orange[50],Colors.orange,Colors.orange[900]];
List<Color> Yellow = [Colors.yellow[50],Colors.yellow,Colors.yellow[900]];
List<Color> Blue = [Colors.blue[50],Colors.blue,Colors.blue[900]];
List<List<Color>> colors =[Red,Orange,Yellow,Blue];

Widget routeSelectionCard(routeSelectionClass rs)
{
  return Card(
    color: colors[rs.color][0],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            child : Icon(Icons.directions_walk,color: Colors.white,),
            backgroundColor: colors[rs.color][1],
          ),
        ),
        Text('${rs.distance}m',style: TextStyle(color: colors[rs.color][1],fontSize: 20,fontFamily: 'BMJUA',textBaseline: TextBaseline.alphabetic ),),
        SizedBox(width: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${rs.time}분',style: TextStyle(color: colors[rs.color][2],fontSize: 40,fontFamily: 'BMJUA'),),
        ),
      ],
    ),

  );
}

class routeSelectionClass
{
  String distance;
  String time;
  int color;
  routeSelectionClass({this.distance,this.color,this.time});
}