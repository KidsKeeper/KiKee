import 'package:flutter/material.dart';

import 'widgets/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build( BuildContext context ) {
    return MaterialApp(

      // debugShowCheckedModeBanner: false,
      
      title: 'Your favorite todo app',

      theme: ThemeData(
        primaryColor: Colors.blue,
      ),

      home: HomeScreen(),

    );
  }
}