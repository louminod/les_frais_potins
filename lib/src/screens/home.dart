import 'package:flutter/material.dart';
import 'package:les_frais_potins/src/models/references/user_role.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/pages/add_image_page.dart';
import 'package:les_frais_potins/src/pages/potins_administrator_page.dart';
import 'package:les_frais_potins/src/pages/potins_page.dart';
import 'package:les_frais_potins/src/pages/test_page.dart';
import 'package:les_frais_potins/src/screens/potins/potin_create.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/services/storage_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class Home extends StatefulWidget {
  final User user;

  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _actualBody;

  @override
  void initState() {
    super.initState();
    setState(() {
      _actualBody = PotinsPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: DatabaseService(userUid: widget.user.uid).userData,
      builder: (context, AsyncSnapshot<UserData> userDataSnapshot) {
        if (userDataSnapshot.hasData) {
          UserData userData = userDataSnapshot.data;
          return Scaffold(
            backgroundColor: Color(0xff392850),
            appBar: AppBar(
              backgroundColor: Color(0xff392860),
            ),
            drawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color(0xff392850),
              ),
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _menu(userData),
                ),
              ),
            ),
            body: _actualBody,
            floatingActionButton: _actualBody is PotinsPage
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePotin()),
                      );
                    },
                    label: Text('Potiner'),
                    icon: Icon(Icons.edit),
                    backgroundColor: Colors.blueAccent,
                  )
                : null,
          );
        } else if (userDataSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error : ${userDataSnapshot.error.toString()}'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Loading(),
            ),
          );
        }
      },
    );
  }

  List<Widget> _menu(UserData userData) {
    List<Widget> menu = _menuUser(userData);
    switch (userData.role) {
      case UserRole.USER:
        menu = _menuUser(userData);
        break;
      case UserRole.MODERATOR:
        menu = _menuModerator(userData);
        break;
      case UserRole.ADMINISTRATOR:
        menu = _menuAdministrator(userData);
        break;
    }
    return menu;
  }

  List<Widget> _menuUser(UserData userData) {
    return [_drawerHeader(userData), _menuItemPotins()];
  }

  List<Widget> _menuModerator(UserData userData) {
    return [
      _drawerHeader(userData),
      _menuItemPotins(),
      _menuItemAdministration(),
      _menuItemAddImage(),
    ];
  }

  List<Widget> _menuAdministrator(UserData userData) {
    return [
      _drawerHeader(userData),
      _menuItemPotins(),
      _menuItemAdministration(),
      _menuItemAddImage(),
      _menuItemTest()
    ];
  }

  Widget _drawerHeader(UserData userData) {
    return DrawerHeader(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.person, color: Colors.white, size: 40),
            Text(
              '${userData.pseudo}',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            RaisedButton.icon(
              color: Colors.redAccent,
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              label: Text(
                "Déconnexion",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await AuthenticationService().signOut();
              },
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xff392860),
      ),
    );
  }

  Widget _menuItemPotins() {
    return ListTile(
      leading: Icon(Icons.message, color: Colors.white),
      title: Text(
        'Potins',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onTap: () {
        setState(() {
          _actualBody = PotinsPage();
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _menuItemAdministration() {
    return ListTile(
      leading: Icon(Icons.build, color: Colors.white),
      title: Text(
        'Administration',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onTap: () {
        setState(() {
          _actualBody = PotinsAdministratorPage();
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _menuItemTest() {
    return ListTile(
      leading: Icon(Icons.widgets, color: Colors.white),
      title: Text(
        'Test',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onTap: () {
        setState(() {
          _actualBody = TestPage();
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _menuItemAddImage() {
    return ListTile(
      leading: Icon(Icons.image, color: Colors.white),
      title: Text(
        'Images',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onTap: () {
        setState(() {
          _actualBody = AddImagePage();
        });
        Navigator.pop(context);
      },
    );
  }
}
