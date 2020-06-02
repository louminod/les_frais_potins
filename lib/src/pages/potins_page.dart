import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';
import 'package:les_frais_potins/src/widgets/potins_list.dart';

class PotinsPage extends StatefulWidget {
  @override
  _PotinsPageState createState() => _PotinsPageState();
}

enum PotinSort { LAST, TOP }
enum PotinTime { TODAY, SEVEN_DAYS, ALL }

class _PotinsPageState extends State<PotinsPage> {
  PotinSort _potinSort;
  PotinTime _potinTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _potinSort = PotinSort.LAST;
      _potinTime = PotinTime.TODAY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Potin>>(
      stream: DatabaseService().potinsValidated,
      builder: (BuildContext context, AsyncSnapshot<List<Potin>> snapshot) {
        if (snapshot.hasData) {
          snapshot.data.sort(
                (a, b) {
              switch (_potinSort) {
                case PotinSort.LAST:
                  return b.creation.compareTo(a.creation);
                case PotinSort.TOP:
                  return b.nbLike.compareTo(a.nbLike);
                default:
                  return a.creation.compareTo(b.creation);
              }
            },
          );

          int day = DateTime
              .now()
              .day;

          List<Potin> potins = snapshot.data.where((potin) {
            switch (_potinTime) {
              case PotinTime.TODAY:
                return potin.creation.day == day;
              case PotinTime.SEVEN_DAYS:
                return potin.creation.day >= (day - 7);
              case PotinTime.ALL:
                return true;
              default:
                return potin.creation.day == day;
            }
          }).toList();

          return Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Derniers potins",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                    IconButton(
                      alignment: Alignment.topCenter,
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              color: Color(0xff392860),
                              child: new Wrap(
                                children: <Widget>[
                                  new ListTile(
                                    leading: new Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Derniers potins',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _potinSort = PotinSort.LAST;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  new ListTile(
                                    leading: new Icon(
                                      Icons.star,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'TOP',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _potinSort = PotinSort.TOP;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: new ListView.builder(
                  itemCount: _lstTimeFilter().length,
                  itemBuilder: (context, index) {
                    return _lstTimeFilter()[index];
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              PotinList(
                potins: potins,
              )
            ],
          );
        } else {
          return Loading();
        }
      },
    );
  }

  List<Widget> _lstTimeFilter() {
    return [
      Container(
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: _potinTime == PotinTime.TODAY
                ? Colors.blueAccent
                : Color(0xffff6e6e),
            borderRadius: BorderRadius.circular(20.0)),
        child: GestureDetector(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 22.0, vertical: 6.0),
              child: Text(
                "Aujourd'hui",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _potinTime = PotinTime.TODAY;
            });
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: _potinTime == PotinTime.SEVEN_DAYS
                ? Colors.blueAccent
                : Color(0xffff6e6e),
            borderRadius: BorderRadius.circular(20.0)),
        child: GestureDetector(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 22.0, vertical: 6.0),
              child: Text(
                "7 jours",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _potinTime = PotinTime.SEVEN_DAYS;
            });
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: _potinTime == PotinTime.ALL
                ? Colors.blueAccent
                : Color(0xffff6e6e),
            borderRadius: BorderRadius.circular(20.0)),
        child: GestureDetector(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 22.0, vertical: 6.0),
              child: Text(
                "Tout",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _potinTime = PotinTime.ALL;
            });
          },
        ),
      ),
    ];
  }
}
