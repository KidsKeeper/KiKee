import 'package:flutter/material.dart';

import '../models/RecentSearch.dart';
import '../models/PlaceInfo.dart';
import '../db/KikeeDB.dart';

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
        future: KikeeDB.instance.getRecentSearch(), // read data from local recentsearch db table
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: ( BuildContext context, int index ) {
                return ListTile(
                  title: Text( snapshot.data[index].mainText ),
                  trailing:
                    IconButton (
                      icon: Icon(Icons.content_copy),
                      onPressed: () {
                        PlaceInfo end = PlaceInfo(
                          description: snapshot.data[index].description,
                          longitude: snapshot.data[index].longitude,
                          latitude: snapshot.data[index].latitude,
                          mainText: snapshot.data[index].mainText
                        );

                        Navigator.pop( context, end ); // send location data to previous page
                      },
                    ),

                    // IconButton(
                    //   alignment: Alignment.center,
                    //   icon: Icon(Icons.delete),
                    //   onPressed: () async {
                    //     _deleteRecentSearch( snapshot.data[index].id );
                    //     setState(() {});
                    //   },
                    // ),
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

// _deleteRecentSearch( int id ) { KikeeDB.instance.deleteRecentSearch(id); }