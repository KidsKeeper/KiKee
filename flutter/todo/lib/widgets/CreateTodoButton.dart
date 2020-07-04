import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../models/Todo.dart';
import '../DatabaseHelper.dart';

final FocusNode fn = new FocusNode();

final searchController = TextEditingController();
final inserttitleTextController = TextEditingController();
final insertdescriptionTextController = TextEditingController();
final updatetitleTextController = TextEditingController();
final updatedescriptionTextController = TextEditingController();

class CreateTodoButton extends StatelessWidget {
  @override
  Widget build( BuildContext context ) {
    return Center(

      child: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              autofocus: false,
              focusNode: fn,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                FlatButton.icon(

                  // onPressed: () {
                  //   DatabaseHelper.instance.getTodo(1).then((data) {
                  //     searchController.text = data[0]['title'];
                  //   });
                  // },
                  onPressed: () {
                    DatabaseHelper.instance.getTodo(1).then((data) {
                      try { _alertToCreateTodo( context, 1, data[0]['title'] ); }
                      catch (error) { _alertToCreateTodo( context, 1, '' ); }
                    });
                    // _alertToCreateTodo(context);
                  },
                  icon: Icon( Icons.add_circle, size: 30.0 ),
                  label: Text('='),

                ),

                FlatButton.icon(
                
                  onPressed: () {},
                  icon: Icon( Icons.check, size: 30.0 ),
                  label: Text(''),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_alertToCreateTodo( BuildContext context, int id, String title ) {
  // update todo
  if( title != '' ) {
    updatetitleTextController.text = title;
    updatedescriptionTextController.text = '';
    print('1');
    Alert(
      context: context,
      title: 'Update a todo',
      content: Column(
        children: <Widget>[
          TextField(
            // controller: TextEditingController(text: title),
            controller: updatetitleTextController,
            decoration: InputDecoration(
              icon: Icon(Icons.star),
            ),
          ),
          TextField(
            controller: updatedescriptionTextController,
            decoration: InputDecoration(
              icon: Icon(Icons.check),
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            _updateTodo( id, updatetitleTextController.text, updatedescriptionTextController.text );
            print('db update');
            // Navigator.pop( context, "Your todo has been updated" );
          },
          child: Text(
            "Todo",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    ).show();
  }

  // insert todo
  else {
    print('2');
    Alert(
      context: context,
      title: 'Add a todo',
      content: Column(
        children: <Widget>[
          TextField(
            controller: inserttitleTextController,
            decoration: InputDecoration(
              icon: Icon(Icons.star),
            ),
          ),
          TextField(
            controller: insertdescriptionTextController,
            decoration: InputDecoration(
              icon: Icon(Icons.check),
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            _saveTodo( id, inserttitleTextController.text, insertdescriptionTextController.text );
            print('db insert');
            // Navigator.pop( context, "Your todo has benn saved" );
          },
          child: Text(
            "Todo",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    ).show();
  }
}

_saveTodo( int id, String title, String content ) async {
  DatabaseHelper.instance.insertTodo(Todo(
    id: id,
    title: inserttitleTextController.text,
    content: insertdescriptionTextController.text
  ));
}

_updateTodo( int id, String title, String content ) async {
  DatabaseHelper.instance.updateTodo(Todo(
    id: id,
    title: updatetitleTextController.text,
    content: updatedescriptionTextController.text
  ));
}