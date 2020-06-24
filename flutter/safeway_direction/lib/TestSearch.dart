import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:safewaydirection/PlaceInfo.dart';
import 'dart:async';


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
  final String PLACES_API_KEY = "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU";
  List<Place> _placesList;
  List<Place> _suggestedList = [
    Place(description: "부산대학교",latitude: 100.0,longitude: 20.0,placeId: 'p1'),
    Place(description: "부산대학교 제 6공학관",latitude: 100.0,longitude: 20.0,placeId: 'p2'),
    Place(description: "부산대학교 메가박스",latitude: 100.0,longitude: 20.0,placeId: 'p3'),
  ];

  void initState() {
    super.initState();
    _placesList = _suggestedList;
    _searchController.addListener(_onSearchChanged);
    _searchController2.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      if(fn.hasFocus){
        getLocationResults(_searchController.text);
      }
      else getLocationResults(_searchController2.text);

    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placesList = _suggestedList;
      });
      return;
    }
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';
    // TODO Add session token
    String request = '$baseURL?input=$input&key=$PLACES_API_KEY&type=$type';
    Response response = await Dio().get(request);

    final predictions = response.data['predictions'];

    List<Place> _displayResults = [];

    for (var i=0; i < predictions.length; i++) {
      String description = predictions[i]['description'];
      String placeId = predictions[i]['placeId'];
      double longitude = predictions[i]['longitude'];
      double latitude = predictions[i]['latitude'];
      _displayResults.add(Place(placeId: placeId,description: description,longitude: longitude,latitude: latitude));
    }

    setState(() {
      _placesList = _displayResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip - Location'),
      ),
      body: Center(
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
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: (){
                      setState(() {
                        if(fn.hasFocus) _searchController.text = "집";
                        else if(fn2.hasFocus){
                          _searchController2.text = "집";
                        }
                      });
                    }, icon: Icon(Icons.home), label: Text('집'),),
                  FlatButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.school),
                      label: Text('학교')),
                  FlatButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.book),
                      label: Text('도서관')),
                  FlatButton.icon(
                    onPressed: null, icon: Icon(Icons.edit), label: Text('수정'),),
                ],
              ),
            ),
            Expanded(
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
                              Flexible(
                                child: Text(_placesList[index].description,
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 25.0)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Placeholder(
                        fallbackHeight: 80,
                        fallbackWidth: 80,
                      ),
                    ],
                  )
                ],
              ),
              onTap: () {
                if(fn.hasFocus) _searchController.text = _placesList[index].description;
                else if(fn2.hasFocus){
                  _searchController2.text = _placesList[index].description;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
