import 'package:flutter/material.dart';

/// description text를 위한 Widget Card.
/// description : text
/// width:만약에 위젯 총 길이 바꾸고싶을때는 Container로 감싸고 width넣기
Widget descriptionCard(String description,double width)
{
  return Card(
    color: Color(0xfffef8be),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0)),
    child:Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 30,
            child: Image.asset('image/_304.png',height: 40,),
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(width: 5.0,),
        Text(
          lineBreak(description,25),
          style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 20,
              fontFamily: 'BMJUA',
              textBaseline: TextBaseline.alphabetic),
        ),
        SizedBox(width: 10.0,),
      ],
    ),
  );
}

///string num자마다 newline return.
String lineBreak(String str,int num)
{
  String returnText ="";
  String tmp = str.substring(0);
  while(tmp.length>num) {
    returnText += tmp.substring(0, num);
    returnText += '\n';
    tmp = (tmp.substring(num));
  }
  if(tmp.length>0) returnText+=tmp.substring(0);
  return returnText;
}