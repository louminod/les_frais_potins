import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';
import 'package:les_frais_potins/src/widgets/potins_administration_list.dart';

class PotinsAdministratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthenticationService().user,
      builder: (context, AsyncSnapshot<User> snapshotUser) {
        if (snapshotUser.hasData) {
          return StreamBuilder<List<Potin>>(
            stream: DatabaseService().potinsCreated,
            builder: (BuildContext context,
                AsyncSnapshot<List<Potin>> snapshotPotins) {
              if (snapshotPotins.hasData) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Potins à valider",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "${snapshotPotins.data.length} potins",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Color(0xffa29aac),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    PotinsAdministationList(
                        potins: snapshotPotins.data,
                        userUid: snapshotUser.data.uid)
                  ],
                );
              } else {
                return Loading();
              }
            },
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
