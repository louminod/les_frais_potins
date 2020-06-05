import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/screens/profile/update_profile.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class ProfilePage extends StatefulWidget {
  User user;
  UserData userData;

  ProfilePage({this.user, this.userData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    return widget.userData != null
        ? Column(
            children: <Widget>[
              SizedBox(height: 30),
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: circleRadius / 2.0, left: 10, right: 10),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 35),
                          ListTile(
                            title: Center(
                              child: Text(
                                widget.userData.pseudo,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Color(0xff392860),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Center(
                              child: Text(
                                widget.user.email,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Color(0xff392860),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.userData.role.toString().split(".")[1],
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.orange,
                                  child: Text(
                                    "MODIFIER",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateProfile()),
                                    );
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.red,
                                  child: Text(
                                    "SUPPRIMER MON COMPTE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title:
                                              new Text("Suppression du compte"),
                                          content:
                                              new Text("Es-tu bien bien sûr ?"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            RaisedButton(
                                              color: Colors.green,
                                              child: Text("OUI"),
                                              onPressed: () async {
                                                // await AuthenticationService().deleteUser();
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Fonction désactivée pour le moment !",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Colors.deepOrangeAccent,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            RaisedButton(
                                              color: Colors.red,
                                              child: Text("NON"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: circleRadius,
                    height: circleRadius,
                    decoration: ShapeDecoration(
                        shape: CircleBorder(), color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.all(circleBorderWidth),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/owl.png"),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        : Loading();
  }
}
