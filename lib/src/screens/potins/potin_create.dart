import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/models/references/potin_status.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class CreatePotin extends StatefulWidget {
  @override
  _CreatePotinState createState() => _CreatePotinState();
}

class _CreatePotinState extends State<CreatePotin> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String title = '';
  String resume = '';
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      appBar: AppBar(
        backgroundColor: Color(0xff392860),
        title: Text("Balance ton potin"),
      ),
      body: loading
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Titre du potin',
                          labelStyle: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Tu dois mettre un titre" : null,
                        onChanged: (val) {
                          setState(() => title = val);
                        },
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Résumé du potin',
                          labelStyle: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Tu dois mettre un résumé" : null,
                        onChanged: (val) {
                          setState(() => resume = val);
                        },
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          labelText: 'Balance tout ici !',
                          labelStyle: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Tu dois mettre un contenu" : null,
                        onChanged: (val) {
                          setState(() => content = val);
                        },
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 50),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.blueAccent,
                        child: Text(
                          'ENVOYER',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });

                            User currentUser =
                                await AuthenticationService().currentUser;

                            Potin potin = Potin(
                              title: title,
                              resume: resume,
                              content: content,
                              status: PotinStatus.CREATED,
                              userUid: currentUser.uid,
                              validatorUid: '',
                              creation: DateTime.now(),
                              nbLike: 0,
                              nbDislike: 0,
                              nbFakeNews: 0,
                            );

                            await DatabaseService().insertPotin(potin);

                            setState(() {
                              loading = false;
                            });
                            Fluttertoast.showToast(
                              msg:
                                  "Ton potin va être examiné par un modérateur avant d'être publié.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.deepOrangeAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
