import 'package:flutter/material.dart';
import 'firstPage.dart';
void main() => runApp(KidsKeeper());

class KidsKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : firstPage(),
    );
  }
}