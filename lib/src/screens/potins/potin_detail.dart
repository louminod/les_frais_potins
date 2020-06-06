import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:les_frais_potins/src/models/interaction.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/models/references/interaction_type.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/services/authentication_service.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class PotinDetail extends StatefulWidget {
  final Potin potin;

  PotinDetail({this.potin});

  @override
  _PotinDetailState createState() => _PotinDetailState();
}

class _PotinDetailState extends State<PotinDetail> {
  bool _interact;

  @override
  void initState() {
    super.initState();
    setState(() {
      _interact = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthenticationService().user,
      builder: (context, AsyncSnapshot<User> userSnapshot) {
        if (userSnapshot.hasData) {
          return StreamBuilder<List<Interaction>>(
            stream: DatabaseService(
                    userUid: userSnapshot.data.uid, potinUid: widget.potin.uid)
                .interactions,
            builder: (context,
                AsyncSnapshot<List<Interaction>> interactionsSnapshot) {
              if (interactionsSnapshot.hasData) {
                return StreamBuilder<UserData>(
                  stream:
                      DatabaseService(userUid: widget.potin.userUid).userData,
                  builder: (context, AsyncSnapshot<UserData> creatorSnapshot) {
                    if (creatorSnapshot.hasData) {
                      return Scaffold(
                        backgroundColor: Color(0xff392850),
                        appBar: AppBar(
                          backgroundColor: Color(0xff392860),
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                            margin:
                                EdgeInsets.only(top: 40, left: 15, right: 15),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/owl.png",
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    widget.potin.title,
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    widget.potin.resume,
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  Text(
                                    'Par ${creatorSnapshot.data.pseudo} | le ${DateFormat('yyyy-MM-dd à kk:mm').format(widget.potin.creation)}',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Color(0xffa29aac),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  Text(
                                    widget.potin.content,
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Color(0xffa29aac),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                        floatingActionButton: FloatingActionButton.extended(
                          elevation: 4.0,
                          icon: const Icon(
                            Icons.movie_filter,
                            color: Color(0xff392860),
                          ),
                          label: const Text(
                            'FAKE NEWS !',
                            style: TextStyle(color: Color(0xff392860)),
                          ),
                          backgroundColor: Colors.greenAccent,
                          onPressed: _interact
                              ? null
                              : () async {
                                  setState(() {
                                    _interact = true;
                                  });
                                  Interaction interaction =
                                      interactionsSnapshot.data.length > 0
                                          ? interactionsSnapshot.data[0]
                                          : null;
                                  await _createInteraction(
                                      interaction,
                                      InteractionType.FAKE_NEWS,
                                      userSnapshot.data);
                                  setState(() {
                                    _interact = false;
                                  });
                                  Navigator.pop(context);
                                },
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,
                        bottomNavigationBar: BottomAppBar(
                          color: Color(0xff392860),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: _interact
                                    ? null
                                    : () async {
                                        setState(() {
                                          _interact = true;
                                        });
                                        Interaction interaction =
                                            interactionsSnapshot.data.length > 0
                                                ? interactionsSnapshot.data[0]
                                                : null;
                                        await _createInteraction(
                                            interaction,
                                            InteractionType.LIKE,
                                            userSnapshot.data);
                                        setState(() {
                                          _interact = false;
                                        });
                                        Navigator.pop(context);
                                      },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.thumb_down,
                                  color: Colors.redAccent,
                                ),
                                onPressed: _interact
                                    ? null
                                    : () async {
                                        setState(() {
                                          _interact = true;
                                        });
                                        Interaction interaction =
                                            interactionsSnapshot.data.length > 0
                                                ? interactionsSnapshot.data[0]
                                                : null;
                                        await _createInteraction(
                                            interaction,
                                            InteractionType.DISLIKE,
                                            userSnapshot.data);
                                        setState(() {
                                          _interact = false;
                                        });
                                        Navigator.pop(context);
                                      },
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (creatorSnapshot.hasError) {
                      return Scaffold(
                        body: Center(
                          child: Text(
                              'ERROR: ${creatorSnapshot.error.toString()}'),
                        ),
                      );
                    } else {
                      return Scaffold(
                        body: Loading(),
                      );
                    }
                  },
                );
              } else if (interactionsSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('ERROR: ${interactionsSnapshot.toString()}'),
                  ),
                );
              } else {
                return Scaffold(
                  body: Loading(),
                );
              }
            },
          );
        } else if (userSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('ERROR: ${userSnapshot.error.toString()}'),
            ),
          );
        } else {
          return Scaffold(
            body: Loading(),
          );
        }
      },
    );
  }

  Future<void> _createInteraction(Interaction interaction,
      InteractionType interactionType, User user) async {
    if (interaction == null) {
      await DatabaseService().insertInteraction(
        Interaction(
          userUid: user.uid,
          potinUid: widget.potin.uid,
          interactionType: interactionType,
        ),
      );
      switch (interactionType) {
        case InteractionType.LIKE:
          widget.potin.nbLike++;
          break;
        case InteractionType.FAKE_NEWS:
          widget.potin.nbFakeNews++;
          break;
        case InteractionType.DISLIKE:
          widget.potin.nbDislike++;
          break;
      }
      await DatabaseService().updatePotin(widget.potin);
    } else {
      if (interaction.interactionType == interactionType) {
        switch (interaction.interactionType) {
          case InteractionType.LIKE:
            widget.potin.nbLike--;
            break;
          case InteractionType.FAKE_NEWS:
            widget.potin.nbFakeNews--;
            break;
          case InteractionType.DISLIKE:
            widget.potin.nbDislike--;
            break;
        }
        await DatabaseService().updatePotin(widget.potin);
        await DatabaseService().deleteInteraction(interaction);
      } else {
        switch (interaction.interactionType) {
          case InteractionType.LIKE:
            widget.potin.nbLike--;
            break;
          case InteractionType.FAKE_NEWS:
            widget.potin.nbFakeNews--;
            break;
          case InteractionType.DISLIKE:
            widget.potin.nbDislike--;
            break;
        }
        switch (interactionType) {
          case InteractionType.LIKE:
            widget.potin.nbLike++;
            break;
          case InteractionType.FAKE_NEWS:
            widget.potin.nbFakeNews++;
            break;
          case InteractionType.DISLIKE:
            widget.potin.nbDislike++;
            break;
        }
        await DatabaseService().updatePotin(widget.potin);
        await DatabaseService().updateInteraction(
          Interaction(
            uid: interaction.uid,
            userUid: user.uid,
            potinUid: widget.potin.uid,
            interactionType: interactionType,
          ),
        );
      }
    }
  }
}
