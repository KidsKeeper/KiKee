import 'package:http/http.dart' as http;

import 'dart:convert';

Map <String, String> headers = {
  'Content-type': 'application/json',
  'Accpet': 'application/json'
};

Future<int> kidsIdCompare( int kidsId ) async {
  Map data = { 'kidsId': kidsId };

  print('kidsId comparing');

  const String URL = 'http://10.0.2.2:8088/kids/id/compare';

  try {
    final response = await http.post(
      Uri.encodeFull(URL),
      headers: headers,
      body: jsonEncode(data)
    );

    kidsId = int.parse(response.body);
  }

  catch (e) { print(e); }

  return kidsId;
}

Future<String> kidsKeyCreate( int kidsId ) async {
  Map data = { 'kidsId': kidsId };
  String key;

  print('get a key');

  const String URL = 'http://10.0.2.2:8088/kids/key/create';

  try {
    final response = await http.post(
      Uri.encodeFull(URL),
      headers: headers,
      body: jsonEncode(data)
    );

    key = response.body;
  }

  catch (e) { print(e); }

  return key;
}