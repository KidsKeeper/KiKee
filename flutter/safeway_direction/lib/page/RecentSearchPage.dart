import 'package:flutter/material.dart';
import 'package:safewaydirection/models/RecentSearch.dart';
import 'package:safewaydirection/db/KikeeDB.dart';


class RecentSearchPage extends StatefulWidget {
  @override
  _RecentSearchPageState createState() => _RecentSearchPageState();
}

class _RecentSearchPageState extends State<RecentSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('최근검색기록') ),
      body: FutureBuilder<List<RecentSearch>>(
        future: KikeeDB.instance.getRecentSearch(),
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: ( BuildContext context, int index ) {
                return ListTile(
                  title: Text( snapshot.data[index].description ),
                  leading: Text( snapshot.data[index].id.toString() ),
                  trailing: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      _deleteRecentSearch( snapshot.data[index].id );
                      setState(() {});
                    },
                  ),
                );
              }
            );
          }

          else if( snapshot.hasError ) return Text('Oops!');
          else return Center( child: CircularProgressIndicator() );
        },
      ),
    );
  }
}

_deleteRecentSearch( int id ) { KikeeDB.instance.deleteRecentSearch(id); }