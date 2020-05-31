import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';

class PasswordForgot extends StatefulWidget {
  @override
  _PasswordForgotState createState() => _PasswordForgotState();
}

class _PasswordForgotState extends State<PasswordForgot> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: Container(
        padding: EdgeInsets.only(top: 80, left: 70, right: 70),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Un email contenant un lien de modification de mot de passe va être envoyé à cette adresse.',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: Colors.white),
                        hintText: 'Remplis ton mail Efrei',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Email Efrei',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (val) =>
                      val.isEmpty || !val.contains("gmail.com")
                          ? "Ton mail doit être celui d'Efrei"
                          : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.blueAccent,
                child: Text(
                  'Envoyer',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await AuthenticationService().sendPasswordResetMail(email);
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: InkWell(
                  child: Text(
                    "Annuler",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
