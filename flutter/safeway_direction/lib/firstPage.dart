import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safewaydirection/secondPage.dart';

class firstPage extends StatelessWidget {
  firstPage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return Scaffold(
      backgroundColor: const Color(0xfffcefa3),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: (height / 5) * 2,
            left: width / 6,
            child: Image.asset(
              'image/_303.png',
              width: (width / 3)*2,
            ),
          ),
          Positioned( //말풍선
            top: height/5,
            left: width/10 ,
            child: GestureDetector(
              onTap: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => secondPage()),
                );
              },
              child: SvgPicture.string(
                _svg_fdjcjx,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
          Positioned(//글씨
            top: height/4.4,
            left: width/7,
            child: Text(
              '검색어를 입력해주세요.',
              style: TextStyle(
                fontFamily: 'BMJUA',
                fontSize: 18,
                color: const Color(0x80f0ad74),
                height: 0.9444444444444444,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_fdjcjx =
    '<svg viewBox="21.0 207.0 333.0 122.6" ><path transform="translate(2863.0, -858.0)" d="M -2785.775390625 1153.410278320312 C -2797.596923828125 1136.499267578125 -2794.52880859375 1119.999633789062 -2794.52880859375 1119.999633789062 L -2754.10986328125 1119.999633789062 C -2754.10986328125 1119.999633789062 -2761.024658203125 1141.263916015625 -2759.308349609375 1158.174072265625 C -2757.592041015625 1175.084106445312 -2747.24365234375 1187.640869140625 -2747.24365234375 1187.640869140625 C -2747.24365234375 1187.640869140625 -2773.954833984375 1170.320434570312 -2785.775390625 1153.410278320312 Z M -2814.499755859375 1119.999633789062 C -2829.687255859375 1119.999633789062 -2842.000244140625 1107.687622070312 -2842.000244140625 1092.500122070312 C -2842.000244140625 1077.311767578125 -2829.687255859375 1064.999755859375 -2814.499755859375 1064.999755859375 L -2536.499755859375 1064.999755859375 C -2521.312255859375 1064.999755859375 -2509.000244140625 1077.311767578125 -2509.000244140625 1092.500122070312 C -2509.000244140625 1107.687622070312 -2521.312255859375 1119.999633789062 -2536.499755859375 1119.999633789062 L -2814.499755859375 1119.999633789062 Z" fill="#fffcea" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
