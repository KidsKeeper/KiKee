import 'package:flutter/material.dart';
// import 'package:safewaydirection/page/ThirdPage.dart';

import 'page/FirstPage2.dart';

void main() => runApp(KidsKeeper());

class KidsKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : FirstPage2());
  }
}
