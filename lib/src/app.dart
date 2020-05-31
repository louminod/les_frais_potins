import 'package:flutter/material.dart';
import 'package:les_frais_potins/src/screens/auth/authentication.dart';
import 'package:les_frais_potins/src/screens/auth/wait_email_validation.dart';
import 'package:les_frais_potins/src/screens/home.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';

import 'models/user.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Les frais Potins',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User>(
        stream: AuthenticationService().user,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data.emailVerified) {
                return Home(user: snapshot.data);
              } else {
                return WaitEmailValidation();
              }
            } else {
              return Authentication();
            }
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else {
            return Authentication();
          }
        },
      ),
    );
  }
}
