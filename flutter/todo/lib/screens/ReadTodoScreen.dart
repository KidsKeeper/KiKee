import 'package:flutter/material.dart';
import 'package:todo/screens/DetailTodoScreen.dart';

import '../models/Todo.dart';
import '../DatabaseHelper.dart';

class ReadTodoScreen extends StatefulWidget {
  @override
  _ReadTodoScreenState createState() => _ReadTodoScreenState();
}

class _ReadTodoScreenState extends State<ReadTodoScreen> {
  @override
  Widget build( BuildContext context ) {
    return Scaffold(

      appBar: AppBar(
        title: Text( 'Saved todo' ),
      ),

      body: FutureBuilder<List<Todo>>(
        future: DatabaseHelper.instance.getAllTodo(),
        builder: ( context, snapshot ) {
          if( snapshot.hasData ) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: ( BuildContext context, int index ) {
                return ListTile(
                  
                  title: Text( snapshot.data[index].title ),
                  leading: Text( snapshot.data[index].id.toString() ),
                  subtitle: Text( snapshot.data[index].content ),
                  onTap: () => _navgateToDeatail( context, snapshot.data[index] ),
                  trailing: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      _deleteTodo(snapshot.data[index]);
                      setState(() {});
                    },
                  ),

                );
              },
            );
          }

          else if( snapshot.hasError ) {
            return Text('Oops!');
          }

          else {
            return Center( child: CircularProgressIndicator() );
          }

        },
      ),
    );
  }
}

_deleteTodo( Todo todo ) {
  DatabaseHelper.instance.deleteTodo(todo.id);
}

_navgateToDeatail( BuildContext context, Todo todo ) async {
  Navigator.push(
    context,
    MaterialPageRoute( builder: (context) => DetailTodoScreen(todo: todo) ),
  );
}