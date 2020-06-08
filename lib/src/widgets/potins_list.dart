import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/screens/potins/potin_detail.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';
import 'package:intl/intl.dart';

class PotinList extends StatelessWidget {
  final List<Potin> potins;

  PotinList({this.potins});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: potins.length > 0
          ? GridView.builder(
              itemCount: potins.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.33),
              ),
              itemBuilder: (BuildContext context, int index) {
                return _potinItem(potins[index], context);
              },
            )
          : Container(
              padding: EdgeInsets.only(top: 70),
              child: Center(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:
                          Image.asset("assets/images/image_03.jpg", width: 300),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Aucun potin !",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _potinItem(Potin potin, BuildContext context) {
    return potin != null
        ? GestureDetector(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xff453658),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _picture(),
                    _data(potin),
                    _interactionBar(potin),
                  ],
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PotinDetail(potin: potin)),
              );
            },
            onLongPress: () async {
              await DatabaseService().deletePotin(potin);
            },
          )
        : Loading();
  }

  Widget _picture() {
    return Image.asset(
      "assets/images/owl.png",
      color: Colors.white,
      width: 70,
    );
  }

  Widget _data(Potin potin) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 120,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              potin.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'le ${DateFormat('yyyy-MM-dd à kk:mm').format(potin.creation)}',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xffa29aac),
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10),
            Text(
              potin.resume,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _interactionBar(Potin potin) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.thumb_up, color: Colors.blueAccent[100]),
              SizedBox(height: 5),
              Text(
                '${potin.nbLike}',
                style: TextStyle(color: Colors.blueAccent[100]),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.movie_filter, color: Colors.greenAccent[200]),
              SizedBox(height: 5),
              Text(
                '${potin.nbFakeNews}',
                style: TextStyle(color: Colors.greenAccent[200]),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.thumb_down, color: Colors.redAccent[100]),
              SizedBox(height: 5),
              Text(
                '${potin.nbDislike}',
                style: TextStyle(color: Colors.redAccent[100]),
              )
            ],
          )
        ],
      ),
    );
  }
}
