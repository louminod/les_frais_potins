import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      appBar: AppBar(
        backgroundColor: Color(0xff392860),
        title: Text('Mise à jour du profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            loading
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Loading(),
                      SizedBox(height: 50),
                    ],
                  )
                : Container(
                    margin: EdgeInsets.only(top: 70),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.white),
                              labelText: 'Changer le mot de passe',
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: 'Nouveau mot de passe',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            obscureText: true,
                            validator: (val) => val.length < 4
                                ? "Trop court !"
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 30.0),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.orange,
                            child: Text(
                              'Mettre à jour',
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

                                bool result = await AuthenticationService().changePassword(password);
                                if(result) {
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    error = 'Erreur lors de la mise à jour !';
                                    loading = false;
                                  });
                                }
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
          ],
        ),
      ),
    );
  }
}
