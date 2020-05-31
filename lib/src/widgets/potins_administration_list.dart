import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/models/references/potin_status.dart';
import 'package:les_frais_potins/src/services/database_service.dart';
import 'package:les_frais_potins/src/widgets/loading.dart';

class PotinsAdministationList extends StatelessWidget {
  final List<Potin> potins;
  final String userUid;

  PotinsAdministationList({this.potins, this.userUid});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: potins.length > 0
          ? ListView.builder(
              itemCount: potins.length,
              itemBuilder: (context, index) {
                return _potinItem(potins[index]);
              },
            )
          : Container(
              padding: EdgeInsets.only(top: 70),
              child: Center(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:
                          Image.asset("assets/images/image_02.jpg", width: 300),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Aucun potin à valider !",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _potinItem(Potin potin) {
    return potin != null
        ? Card(
            elevation: 7,
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(potin.title),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Par Bob'),
                      SizedBox(width: 5),
                      Text(' | '),
                      SizedBox(width: 5),
                      Text(
                          'Le ${DateFormat('yyyy-MM-dd à kk:mm').format(potin.creation)}'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(potin.resume),
                  SizedBox(height: 10),
                  Text(potin.content),
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Colors.green,
                    child: Text(
                      "VALIDER",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      potin.status = PotinStatus.VALIDATED;
                      potin.validatorUid = userUid;
                      await DatabaseService().updatePotin(potin);
                    },
                  )
                ],
              ),
            ),
          )
        : Loading();
  }
}
