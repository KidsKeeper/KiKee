import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../SearchPage.dart';
import 'iPhoneXXSpage21.dart';

class iPhoneXXSmainpage5 extends StatelessWidget {
  iPhoneXXSmainpage5({
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
                  MaterialPageRoute(builder: (context) => SearchPage()),
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

const String _svg_c9w201 =
    '<svg viewBox="2442.1 779.3 6.8 13.8" ><path transform="matrix(0.707107, 0.707107, -0.707107, 0.707107, 2448.91, 779.27)" d="M 0 0 L 0 9.63812255859375" fill="none" stroke="#707070" stroke-width="2" stroke-miterlimit="4" stroke-linecap="round" /><path transform="matrix(-0.707107, 0.707107, -0.707107, -0.707107, 2448.91, 793.09)" d="M 0 0 L 0 9.63812255859375" fill="none" stroke="#707070" stroke-width="2" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_nbwld4 =
    '<svg viewBox="74.5 778.5 12.0 15.0" ><path transform="translate(74.5, 778.5)" d="M 0 0 L 0 15" fill="none" stroke="#707070" stroke-width="2" stroke-miterlimit="4" stroke-linecap="round" /><path transform="translate(80.5, 778.5)" d="M 0 0 L 0 15" fill="none" stroke="#707070" stroke-width="2" stroke-miterlimit="4" stroke-linecap="round" /><path transform="translate(86.5, 778.5)" d="M 0 0 L 0 15" fill="none" stroke="#707070" stroke-width="2" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_xx0ljg =
    '<svg viewBox="0.0 0.0 24.3 11.3" ><path transform="translate(-336.0, 26.67)" d="M 338.6666870117188 -26.66666984558105 L 355.3333129882812 -26.66666984558105 L 355.3333129882812 -26.66666984558105 C 356.8060913085938 -26.66666984558105 358 -25.47275924682617 358 -24 L 358 -18 L 358 -18 C 358 -16.52724075317383 356.8060913085938 -15.33333015441895 355.3333129882812 -15.33333015441895 L 338.6666870117188 -15.33333015441895 L 338.6666870117188 -15.33333015441895 C 337.1939086914062 -15.33333015441895 336 -16.52724075317383 336 -18 L 336 -24 L 336 -24 C 336 -25.47275924682617 337.1939086914062 -26.66666984558105 338.6666870117188 -26.66666984558105 Z" fill="none" fill-opacity="0.35" stroke="#343638" stroke-width="1" stroke-opacity="0.35" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-336.0, 26.67)" d="M 359 -23 L 359 -19 C 359.8046875 -19.33877944946289 360.3280029296875 -20.12686920166016 360.3280029296875 -21 C 360.3280029296875 -21.87313079833984 359.8046875 -22.66122055053711 359 -23" fill="#343638" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-336.0, 26.67)" d="M 339.3333129882812 -24.66666984558105 L 354.6666870117188 -24.66666984558105 L 354.6666870117188 -24.66666984558105 C 355.4030151367188 -24.66666984558105 356 -24.06970977783203 356 -23.33333015441895 L 356 -18.66666984558105 L 356 -18.66666984558105 C 356 -17.93029022216797 355.4030151367188 -17.33333015441895 354.6666870117188 -17.33333015441895 L 339.3333129882812 -17.33333015441895 L 339.3333129882812 -17.33333015441895 C 338.5969848632812 -17.33333015441895 338 -17.93029022216797 338 -18.66666984558105 L 338 -23.33333015441895 L 338 -23.33333015441895 C 338 -24.06970977783203 338.5969848632812 -24.66666984558105 339.3333129882812 -24.66666984558105 Z" fill="#343638" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_x9q8kz =
    '<svg viewBox="0.0 1.0 375.0 46.0" ><path transform="translate(0.0, 45.0)" d="M 0 -44 L 375 -44 L 375 2 L 0 2 L 0 -44 Z" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_31ra30 =
    '<svg viewBox="0.0 0.0 17.0 10.7" ><path transform="translate(-293.67, 26.33)" d="M 294.6666870117188 -19.66666984558105 L 295.6666870117188 -19.66666984558105 C 296.218994140625 -19.66666984558105 296.6666870117188 -19.21895027160645 296.6666870117188 -18.66666984558105 L 296.6666870117188 -16.66666984558105 C 296.6666870117188 -16.1143798828125 296.218994140625 -15.66666984558105 295.6666870117188 -15.66666984558105 L 294.6666870117188 -15.66666984558105 C 294.1144104003906 -15.66666984558105 293.6666870117188 -16.1143798828125 293.6666870117188 -16.66666984558105 L 293.6666870117188 -18.66666984558105 C 293.6666870117188 -19.21895027160645 294.1144104003906 -19.66666984558105 294.6666870117188 -19.66666984558105 L 294.6666870117188 -19.66666984558105 Z M 299.3333129882812 -21.66666984558105 L 300.3333129882812 -21.66666984558105 C 300.8855895996094 -21.66666984558105 301.3333129882812 -21.21895027160645 301.3333129882812 -20.66666984558105 L 301.3333129882812 -16.66666984558105 C 301.3333129882812 -16.1143798828125 300.8855895996094 -15.66666984558105 300.3333129882812 -15.66666984558105 L 299.3333129882812 -15.66666984558105 C 298.781005859375 -15.66666984558105 298.3333129882812 -16.1143798828125 298.3333129882812 -16.66666984558105 L 298.3333129882812 -20.66666984558105 C 298.3333129882812 -21.21895027160645 298.781005859375 -21.66666984558105 299.3333129882812 -21.66666984558105 Z M 304 -24 L 305 -24 C 305.5523071289062 -24 306 -23.55228042602539 306 -23 L 306 -16.66666984558105 C 306 -16.1143798828125 305.5523071289062 -15.66666984558105 305 -15.66666984558105 L 304 -15.66666984558105 C 303.4476928710938 -15.66666984558105 303 -16.1143798828125 303 -16.66666984558105 L 303 -23 C 303 -23.55228042602539 303.4476928710938 -24 304 -24 Z M 308.6666870117188 -26.33333015441895 L 309.6666870117188 -26.33333015441895 C 310.218994140625 -26.33333015441895 310.6666870117188 -25.8856201171875 310.6666870117188 -25.33333015441895 L 310.6666870117188 -16.66666984558105 C 310.6666870117188 -16.1143798828125 310.218994140625 -15.66666984558105 309.6666870117188 -15.66666984558105 L 308.6666870117188 -15.66666984558105 C 308.1144104003906 -15.66666984558105 307.6666870117188 -16.1143798828125 307.6666870117188 -16.66666984558105 L 307.6666870117188 -25.33333015441895 C 307.6666870117188 -25.8856201171875 308.1144104003906 -26.33333015441895 308.6666870117188 -26.33333015441895 L 308.6666870117188 -26.33333015441895 Z" fill="#343638" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_8txzf6 =
    '<svg viewBox="309.4 15.4 15.3 11.0" ><path transform="translate(-6.33, 42.05)" d="M 323.3302917480469 -24.39200019836426 C 325.5462036132812 -24.39189910888672 327.6773986816406 -23.54047012329102 329.2832946777344 -22.01366996765137 C 329.404296875 -21.89579010009766 329.5975952148438 -21.89727973937988 329.7167053222656 -22.01700019836426 L 330.8727111816406 -23.18367004394531 C 330.9330139160156 -23.2443904876709 330.9666137695312 -23.32663917541504 330.9660949707031 -23.4122200012207 C 330.9656066894531 -23.49780082702637 330.9309997558594 -23.57965087890625 330.8699951171875 -23.63966941833496 C 326.6549072265625 -27.6792106628418 320.0050964355469 -27.6792106628418 315.7900085449219 -23.63966941833496 C 315.7289123535156 -23.5797004699707 315.6943054199219 -23.49786949157715 315.6936950683594 -23.41229057312012 C 315.6932067871094 -23.32670974731445 315.7267150878906 -23.24443054199219 315.7869873046875 -23.18367004394531 L 316.9432983398438 -22.01700019836426 C 317.0624084472656 -21.8971004486084 317.2557983398438 -21.89561080932617 317.376708984375 -22.01366996765137 C 318.9827880859375 -23.54056930541992 321.1141967773438 -24.39200973510742 323.3302917480469 -24.39200019836426 L 323.3302917480469 -24.39200019836426 Z M 323.3302917480469 -20.5963306427002 C 324.5477905273438 -20.59641075134277 325.7218933105469 -20.14388084411621 326.6242980957031 -19.32666969299316 C 326.7463989257812 -19.21068954467773 326.9386901855469 -19.21319961547852 327.0577087402344 -19.33233070373535 L 328.2123107910156 -20.49900054931641 C 328.2731018066406 -20.56019020080566 328.306884765625 -20.64320945739746 328.3059997558594 -20.7294807434082 C 328.3051147460938 -20.81574058532715 328.2697143554688 -20.89805030822754 328.2077026367188 -20.95800018310547 C 325.4595031738281 -23.51437950134277 321.2034912109375 -23.51437950134277 318.4552917480469 -20.95800018310547 C 318.393310546875 -20.89805030822754 318.3577880859375 -20.81570053100586 318.3569946289062 -20.72941017150879 C 318.356201171875 -20.64311981201172 318.3901062011719 -20.56011009216309 318.4509887695312 -20.49900054931641 L 319.6052856445312 -19.33233070373535 C 319.7243041992188 -19.21319961547852 319.9165954589844 -19.21068954467773 320.0386962890625 -19.32666969299316 C 320.9404907226562 -20.14333915710449 322.1135864257812 -20.5958309173584 323.3302917480469 -20.5963306427002 L 323.3302917480469 -20.5963306427002 Z M 325.5492858886719 -17.8120002746582 C 325.6111145019531 -17.87261009216309 325.6451110839844 -17.95601081848145 325.643310546875 -18.04250907897949 C 325.6416015625 -18.12902069091797 325.6041870117188 -18.21096992492676 325.5400085449219 -18.26899909973145 C 324.264404296875 -19.34787940979004 322.3962097167969 -19.34787940979004 321.1206970214844 -18.26899909973145 C 321.056396484375 -18.21100997924805 321.0190124511719 -18.12908935546875 321.0172119140625 -18.04258918762207 C 321.0152893066406 -17.95607948303223 321.0492858886719 -17.87265014648438 321.1109924316406 -17.8120002746582 L 323.1087036132812 -15.79633045196533 C 323.1672058105469 -15.73709011077881 323.2470092773438 -15.70376014709473 323.3302917480469 -15.70376014709473 C 323.4136047363281 -15.70376014709473 323.493408203125 -15.73709011077881 323.552001953125 -15.79633045196533 L 325.5492858886719 -17.8120002746582 Z" fill="#343638" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_socz7d =
    '<svg viewBox="0.0 0.0 30.2 16.0" ><path transform="translate(-21.0, 35.0)" d="M 21 -19 L 51.21133041381836 -19 L 51.21133041381836 -35 L 21 -35 L 21 -19 Z" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fdjcjx =
    '<svg viewBox="21.0 207.0 333.0 122.6" ><path transform="translate(2863.0, -858.0)" d="M -2785.775390625 1153.410278320312 C -2797.596923828125 1136.499267578125 -2794.52880859375 1119.999633789062 -2794.52880859375 1119.999633789062 L -2754.10986328125 1119.999633789062 C -2754.10986328125 1119.999633789062 -2761.024658203125 1141.263916015625 -2759.308349609375 1158.174072265625 C -2757.592041015625 1175.084106445312 -2747.24365234375 1187.640869140625 -2747.24365234375 1187.640869140625 C -2747.24365234375 1187.640869140625 -2773.954833984375 1170.320434570312 -2785.775390625 1153.410278320312 Z M -2814.499755859375 1119.999633789062 C -2829.687255859375 1119.999633789062 -2842.000244140625 1107.687622070312 -2842.000244140625 1092.500122070312 C -2842.000244140625 1077.311767578125 -2829.687255859375 1064.999755859375 -2814.499755859375 1064.999755859375 L -2536.499755859375 1064.999755859375 C -2521.312255859375 1064.999755859375 -2509.000244140625 1077.311767578125 -2509.000244140625 1092.500122070312 C -2509.000244140625 1107.687622070312 -2521.312255859375 1119.999633789062 -2536.499755859375 1119.999633789062 L -2814.499755859375 1119.999633789062 Z" fill="#fffcea" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_3qy9hc =
    '<svg viewBox="0.0 0.0 166.5 222.0" ><path transform="translate(-348.67, -280.0)" d="M 431.9151916503906 280 C 386.009521484375 280 348.6669921875 317.3468017578125 348.6669921875 363.2482604980469 C 348.6669921875 424.6637573242188 425.4747924804688 497.6594543457031 428.7447814941406 500.7396850585938 C 429.6388854980469 501.5752258300781 430.7770385742188 501.9953308105469 431.9151916503906 501.9953308105469 C 433.0533752441406 501.9953308105469 434.1914672851562 501.5752258300781 435.0859375 500.7396850585938 C 438.3556823730469 497.6594543457031 515.1634521484375 424.6637573242188 515.1634521484375 363.2482604980469 C 515.1634521484375 317.3468017578125 477.8208923339844 280 431.9151916503906 280 Z M 431.9151916503906 409.4973754882812 C 406.4148254394531 409.4973754882812 385.666015625 388.7486572265625 385.666015625 363.2482604980469 C 385.666015625 337.7478332519531 406.4152526855469 316.9991149902344 431.9151916503906 316.9991149902344 C 457.4150695800781 316.9991149902344 478.1643371582031 337.7482604980469 478.1643371582031 363.2482604980469 C 478.1643371582031 388.7481994628906 457.4156494140625 409.4973754882812 431.9151916503906 409.4973754882812 Z" fill="#ff9100" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_yd9d10 =
    '<svg viewBox="5.3 45.5 49.0 22.9" ><path transform="translate(5.31, 33.96)" d="M 49.02223968505859 11.5 C 49.02223968505859 24.1707649230957 38.04823684692383 34.44245147705078 24.5111198425293 34.44245147705078 C 10.97400188446045 34.44245147705078 0 24.1707649230957 0 11.5 C 20.79712677001953 11.5 44.05121231079102 11.5 49.02223968505859 11.5 Z" fill="#ffc300" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(2560.52, -633.41)" d="M -2547.18896484375 695.8345336914062 C -2542.834716796875 692.1246337890625 -2537.047607421875 689.863525390625 -2530.695556640625 689.863525390625 C -2524.34326171875 689.863525390625 -2518.555908203125 692.124755859375 -2514.201416015625 695.8345947265625 C -2518.5556640625 699.5444946289062 -2524.3427734375 701.8056030273438 -2530.69482421875 701.8056030273438 C -2537.047119140625 701.8056030273438 -2542.83447265625 699.5443725585938 -2547.18896484375 695.8345336914062 Z" fill="#fff700" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_mu4rm2 =
    '<svg viewBox="19.3 21.8 128.2 128.2" ><path transform="translate(19.28, 21.83)" d="M 64.09920501708984 0 C 99.50022125244141 0 128.1984100341797 28.69819068908691 128.1984100341797 64.09920501708984 C 128.1984100341797 99.50022888183594 99.50022125244141 128.1984100341797 64.09920501708984 128.1984100341797 C 28.69818878173828 128.1984100341797 0 99.50022888183594 0 64.09920501708984 C 0 28.69819068908691 28.69818878173828 0 64.09920501708984 0 Z" fill="#fffde0" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
