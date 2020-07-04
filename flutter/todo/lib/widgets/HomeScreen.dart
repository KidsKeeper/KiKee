import 'package:flutter/material.dart';
import 'CreateTodoButton.dart';
import 'ReadTodoButton.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build( BuildContext context ) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Create a todo')
      ),

      body: Column(
        children: <Widget>[
          Center( child: CreateTodoButton() ),
          Center( child: ReadTodoButton() ),
        ],
      ),
      
    );
  }
}