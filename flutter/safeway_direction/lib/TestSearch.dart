import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'LocalDB.dart';
import 'PlaceInfo.dart';

class TestSearch extends StatefulWidget {
  @override
  _TestSearchState createState() => _TestSearchState();
}

class _TestSearchState extends State<TestSearch> {
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _searchController2 = new TextEditingController();
  FocusNode fn = new FocusNode();
  FocusNode fn2 = new FocusNode();
  Timer _throttle;
  DataBase db = new DataBase();
  bool firstTime = true;
  final String PLACES_API_KEY = "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU";
  List<Place> _placesList;
  List<Place> _suggestedList = [];
  String title1 = "최근 검색";
  String title2 = "검색 내용";
  String heading;
  initState() {
    super.initState();
    _placesList = _suggestedList;
    heading = title1;
    _searchController.addListener(_onSearchChanged);
    _searchController2.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      if (fn.hasFocus) {
        getLocationResults(_searchController.text);
      } else
        getLocationResults(_searchController2.text);
    });
  }

  Future<List<Place>> _fetchData() async {
    db.databaseInit();
    await Future.delayed(const Duration(seconds: 1), () {});
    return db.GetRecentSearch();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void getLocationResults(String input) async {
    firstTime = false;
    if (input.isEmpty) {
      setState(() {
        heading = title1;
        _placesList = _suggestedList;
      });
      return;
    }

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';
    String language = 'ko';

    // TODO Add session token
    String request = '$baseURL?input=$input&key=$PLACES_API_KEY&language=$language';
    Response response = await Dio().get(request);

    final predictions = response.data['predictions'];

    List<Place> _displayResults = [];

    for (var i = 0; i < predictions.length; i++) {
      String description = predictions[i]['description'];
      String placeId = predictions[i]['place_id'];
      String main_text = predictions[i]['structured_formatting']['main_text'];
      String secondary_text = predictions[i]['structured_formatting']['secondary_text'];
      double longitude = predictions[i]['longitude'];
      double latitude = predictions[i]['latitude'];
      _displayResults.add(Place(
          placeId: placeId,
          description: description,
          longitude: longitude,
          latitude: latitude));
    }

    setState(() {
      heading = title2;
      _placesList = _displayResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                focusNode: fn,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefix: Text('내위치:'),
                    filled: true,
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _searchController2,
                autofocus: false,
                focusNode: fn2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  prefix: Text('도착지:'),
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    String tmp = _searchController2.text;
                    _searchController2.text = _searchController.text;
                    _searchController.text = tmp;
                  },
                  icon: Icon(Icons.swap_vert),
                ),
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _searchController2.clear();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: () {
                      setState(() {
                        if (fn.hasFocus)
                          _searchController.text = "집";
                        else if (fn2.hasFocus) {
                          _searchController2.text = "집";
                        }
                      });
                    },
                    icon: Icon(Icons.home),
                    label: Text('집'),
                  ),
                  FlatButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.school),
                      label: Text('학교')),
                  FlatButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.book),
                      label: Text('도서관')),
                  FlatButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.edit),
                    label: Text('수정'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Text('$heading',textAlign: TextAlign.left,),
            ),
            firstTime
                ? FutureBuilder(
              future: _fetchData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return CircularProgressIndicator();
                } else {
                  _suggestedList = snapshot.data;
                  _placesList = _suggestedList;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _placesList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildPlaceCard(context, index),
                    ),
                  );
                }
              },
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPlaceCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "SelectedTrip-${_placesList[index].description}",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Card(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              heading==title1?Icon(Icons.access_time):Icon(Icons.search),
                              SizedBox(width: 4,),
                              Flexible(
                                child: Text(_placesList[index].description,
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 15.0)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () async{
                if (fn.hasFocus) {
                  _searchController.text = _placesList[index].description;
                  db.insertRecentSearch(_placesList[index].description,
                      _placesList[index].placeId,
                      10.0, 10.0);
                  _suggestedList = await db.GetRecentSearch();
                  setState(() {});
                }
                else if (fn2.hasFocus) {
                  _searchController2.text = _placesList[index].description;
                  db.insertRecentSearch(_placesList[index].description,
                      _placesList[index].placeId,
                      10.0, 10.0);
                  _suggestedList = await db.GetRecentSearch();
                  setState(() {});
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
