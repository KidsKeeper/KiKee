import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> showMyDialog(BuildContext context,String msg) async{
  return Alert(
    context: context,
    title: msg,
    style: AlertStyle(
      titleStyle: TextStyle( fontFamily: 'BMJUA',color: Colors.black26,fontSize: 20),
      backgroundColor: Color(0xfffdfbf4),
      alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0),),
      ),
    ),
//    content: Text(msg,style:TextStyle( fontFamily: 'BMJUA',color: Colors.black,fontSize: 20)),
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





//Future<void> showMyDialog(BuildContext context,String msg) async {
//  return showDialog<void>(
//    context: context,
//    barrierDismissible: true, // user must tap button!
//    builder: (BuildContext context) {
//      return AlertDialog(
//        //title: Text('앗!',style:TextStyle(fontFamily: 'BMJUA', fontSize: 18, color: Colors.black)),
//        content: SingleChildScrollView(
//          child: Text(msg,style:TextStyle(fontFamily: 'BMJUA', fontSize: 18, color: Colors.black),)
//        ),
//        contentPadding: EdgeInsets.fromLTRB(30,20,30,0),
//        buttonPadding: EdgeInsets.fromLTRB(0,0,20,0),
//        backgroundColor: Color(0xfffdfbf4).withOpacity(0.9),
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//        actions: <Widget>[
//          FlatButton(
//            child: Text('알겠습니다.',style:TextStyle(fontFamily: 'BMJUA', fontSize: 18, color: Colors.orange),),
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//          ),
//        ],
//      );
//    },
//  );
//}