import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String result = '-';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'ZONE DE TEST',
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: Colors.blueAccent,
            child: Text(
              'LANCER LE TEST !',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              List<AssetImage> images = [];

              for (int i = 2; i < 5; i++) {
                images.add(AssetImage('assets/images/image_0' + i.toString() + '.jpg'));
              }

              setState(() {
                result = 'Test terminé';
              });
            },
          ),
          SizedBox(height: 30),
          Text(
            'Résultat:',
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '$result',
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
