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

enum PotinFilter { LAST, TOP }

class _PotinsPageState extends State<PotinsPage> {
  PotinFilter _potinFilter;

  @override
  void initState() {
    super.initState();
    setState(() {
      _potinFilter = PotinFilter.LAST;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Potin>>(
      stream: DatabaseService().potinsValidated,
      builder: (BuildContext context, AsyncSnapshot<List<Potin>> snapshot) {
        if (snapshot.hasData) {
          snapshot.data.sort((a, b) {
            switch (_potinFilter) {
              case PotinFilter.LAST:
                return b.creation.compareTo(a.creation);
              case PotinFilter.TOP:
                return b.nbLike.compareTo(a.nbLike);
              default:
                return a.creation.compareTo(b.creation);
            }
          });

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
                        Text(
                          "${snapshot.data.length} nouveautées",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Color(0xffa29aac),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
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
                                      'Dernier potins',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _potinFilter = PotinFilter.LAST;
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
                                      'TOP du TOP',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _potinFilter = PotinFilter.TOP;
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
                height: 40,
              ),
              PotinList(
                potins: snapshot.data,
              )
            ],
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
