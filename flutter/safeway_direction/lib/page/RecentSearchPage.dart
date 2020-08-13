import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfffdee96),
        title: Text('최근 검색기록',style: TextStyle(fontFamily: 'BMJUA',color: Colors.orange,fontSize: 25),),
      ),
      body: FutureBuilder<List<RecentSearch>>(
        future: KikeeDB.instance.getRecentSearch(), // read data from local recentsearch db table
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return ListView.separated(
              padding: EdgeInsets.all(10),
                separatorBuilder: (context, index) => Divider(
                  color: Color(0xFFF0AD74),
                ),
              itemCount: snapshot.data.length,
              itemBuilder: ( BuildContext context, int index ) {
                return ListTile(
                    onTap: () {
                      PlaceInfo end = PlaceInfo(
                          description: snapshot.data[index].description,
                          longitude: snapshot.data[index].longitude,
                          latitude: snapshot.data[index].latitude,
                          mainText: snapshot.data[index].mainText
                      );
                      Navigator.pop( context, end ); // send location data to previous page
                    },
                  title: Text( snapshot.data[index].mainText,style: TextStyle(fontFamily: 'BMJUA',fontSize: 17),),
                  subtitle: Text( snapshot.data[index].description,style: TextStyle(fontFamily: 'BMJUA',fontSize: 10),),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF0AD74),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child:IconButton (
                      icon: Icon(Icons.schedule,color: Color(0xfffdee96),size: 30,),
                      onPressed: () {},
                  ),)

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