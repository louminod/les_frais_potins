import 'package:flutter/material.dart';
import 'package:les_frais_potins/src/screens/auth/login.dart';
import 'package:les_frais_potins/src/screens/auth/register.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showLogin = true;

  void toggleView() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return showLogin ? Login(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}
