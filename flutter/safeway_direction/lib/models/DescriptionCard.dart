import 'package:flutter/material.dart';

/// description text를 위한 Widget Card.
/// description : text
/// width:만약에 위젯 총 길이 바꾸고싶을때는 Container로 감싸고 width넣기
Widget descriptionCard(String description,int distance,int time)
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
            child: Image.asset('image/kiki.png',height: 50,),
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(width: 5.0,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              lineBreak(description,15),
              style: TextStyle(
                  color: Color(0xFFFFA100),
                  fontSize: 20,
                  fontFamily: 'BMJUA',
                  textBaseline: TextBaseline.alphabetic),
            ),
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                Icon(Icons.room,size: 10,color: Color(0xFFF5BE60)),
                Text(" 남은 거리 $distance m",style: TextStyle(color: Color(0xFFF5BE60),fontFamily: 'BMJUA',fontSize: 12),),
                SizedBox(width: 15,),
                Icon(Icons.access_time,size: 10,color: Color(0xFFF5BE60)),
                Text(" 남은 시간 ${timeReturn(time)}",style: TextStyle(color: Color(0xFFF5BE60),fontFamily: 'BMJUA',fontSize: 12)),
              ],
            ),
          ],
        ),
        SizedBox(width: 15.0,),
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
//분이랑 초 return
String timeReturn(int time)
{
  if(time>=60) {
    return (time~/60).toString()+"분";
  }
  else {
    return time.toString()+"초";
  }
}