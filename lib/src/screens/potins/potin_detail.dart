import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class PotinDetail extends StatelessWidget {
  final Potin potin;

  PotinDetail({this.potin});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService(userUid: potin.userUid).userData,
      builder: (context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xff392850),
            appBar: AppBar(
              backgroundColor: Color(0xff392860),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 40, left: 15, right: 15),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/owl.png",
                        width: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 30),
                      Text(
                        potin.title,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 30),
                      Text(
                        potin.resume,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 35),
                      Text(
                        'Par ${snapshot.data.pseudo} | le ${DateFormat('yyyy-MM-dd à kk:mm').format(potin.creation)}',
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Color(0xffa29aac),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 35),
                      Text(
                        potin.content,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Color(0xffa29aac),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              elevation: 4.0,
              icon: const Icon(
                Icons.movie_filter,
                color: Color(0xff392860),
              ),
              label: const Text(
                'FAKE NEWS !',
                style: TextStyle(color: Color(0xff392860)),
              ),
              backgroundColor: Colors.greenAccent,
              onPressed: () {},
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: Color(0xff392860),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.thumb_down,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('ERROR: ${snapshot.error.toString()}'),
            ),
          );
        } else {
          return Scaffold(
            body: Loading(),
          );
        }
      },
    );
  }
}
