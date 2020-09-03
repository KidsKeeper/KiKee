import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> showMyDialog(BuildContext context,String msg) async{
  return Alert(
    type: AlertType.warning,
    context: context,
    title: '조심하세요!',
    style: AlertStyle(
      titleStyle: TextStyle( fontFamily: 'BMJUA',color: Colors.orangeAccent,fontSize: 30),
      backgroundColor: Color(0xfffdfbf4),
      alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0),),
      ),
    ),
      content: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Text(msg,style:TextStyle( fontFamily: 'BMJUA',color: Colors.black54,fontSize: 20),textAlign: TextAlign.center,),
          SizedBox(height: 5,),
        ],
      ),
    buttons: [
      DialogButton(
          color: Color(0xfff7b413),
          radius: BorderRadius.circular(30),
          onPressed: () {
            Navigator.pop(context);
          },
          child:
          Text("네", style: TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'BMJUA'))
      ),
    ],
    closeFunction: ()=>{} //it's nothing but if you deleted this, errors appear.
  ).show();
}