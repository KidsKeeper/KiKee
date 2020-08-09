import 'package:flutter/material.dart';

import '../db/KikeeDB.dart';
import '../models/Kids.dart';

class DBpage extends StatefulWidget {
  @override
  _DBpageState createState() => _DBpageState();
}

class _DBpageState extends State<DBpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('디비 목록 결과') ),
      // body: FutureBuilder<List<Parents>>(
      body: FutureBuilder<List<Kids>>(
        // future: DB.instance.getParents(),
        future: KikeeDB.instance.getKids(),
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  // title: Text( snapshot.data[index].parentsId.toString() ),
                  title: Text( snapshot.data[index].kidsId.toString() ),
                  // subtitle: Text( snapshot.data[index].key.toString() ),
                  subtitle: Text( snapshot.data[index].key.toString() ),
                  trailing: 
                    IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        // _deleteParents();
                        _deletekidsId();
                        setState(() {});
                      },
                    ),
                );
              }
            );
          }

          else if( snapshot.hasError ) return Text('error');
          else return Center( child: CircularProgressIndicator() );
        },
      ),
    );
  }
}

// _deleteParents() { DB.instance.deleteParentsId(); }
_deletekidsId() { KikeeDB.instance.deleteKidsId(1); }