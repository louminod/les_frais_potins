import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';
import 'package:les_frais_potins/src/services/pseudo_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(child: Image.asset("assets/images/logo.png")),
            ),
            loading
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Loading(),
                      SizedBox(height: 50),
                    ],
                  )
                : Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.white),
                              hintText: 'Remplis ton mot de passe',
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: 'Mot de passe',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            obscureText: true,
                            validator: (val) => val.isEmpty
                                ? "N'oublie pas le mot de passe"
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.white),
                              hintText: 'Confirme ton mot de passe',
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: 'Encore ton mot de passe',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            obscureText: true,
                            validator: (val) => val != password
                                ? "Le mot de passe est différent !"
                                : null,
                            onChanged: (val) {
                              setState(() => password2 = val);
                            },
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 40.0),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.blueAccent,
                            child: Text(
                              'Créer',
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
                                String pseudo = await PseudoService().generatePseudo();
                                dynamic result = await AuthenticationService()
                                    .signUp(pseudo, email, password);
                                if (result is User) {
                                  setState(() {
                                    loading = false;
                                  });
                                } else if (result is PlatformException) {
                                  setState(() {
                                    error = result.message;
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
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: InkWell(
                child: Text(
                  "Se connecter",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () => widget.toggleView(),
              ),
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
