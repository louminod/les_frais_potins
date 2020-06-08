import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/models/references/potin_status.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class PotinsModerationList extends StatelessWidget {
  final List<Potin> potins;
  final String userUid;

  PotinsModerationList({this.potins, this.userUid});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: potins.length > 0
          ? ListView.builder(
              itemCount: potins.length,
              itemBuilder: (context, index) {
                return _potinItem(potins[index]);
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
                          Image.asset("assets/images/image_02.jpg", width: 300),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Aucun potin à valider !",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _potinItem(Potin potin) {
    return potin != null
        ? Card(
            color: Colors.deepOrange,
            elevation: 7,
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                potin.title,
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    potin.resume,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Par  | le ${DateFormat('yyyy-MM-dd à kk:mm').format(potin.creation)}',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    potin.content,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        child: Text(
                          "VALIDER",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          potin.status = PotinStatus.VALIDATED;
                          potin.validatorUid = userUid;
                          await DatabaseService().updatePotin(potin);
                        },
                      ),
                      RaisedButton(
                        color: Colors.red[600],
                        child: Text(
                          "REFUSER",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          potin.status = PotinStatus.REFUSED;
                          potin.validatorUid = userUid;
                          await DatabaseService().updatePotin(potin);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        : Loading();
  }
}
