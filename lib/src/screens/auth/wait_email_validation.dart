import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';

class WaitEmailValidation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Tu dois vérifier le lien envoyé à ton adresse email !',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 40),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.blueAccent,
                child: Text(
                  'Retour',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  await AuthenticationService().signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
