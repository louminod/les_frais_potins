import 'package:flutter/material.dart';

class AddImagePage extends StatefulWidget {
  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  List<AssetImage> listOfImage;
  bool clicked = false;
  List<String> listOfStr = List();
  String images;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this._getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _getImages() {
    listOfImage = List();
    for (int i = 0; i < 6; i++) {
      listOfImage.add(
          AssetImage('assets/images/travelimage' + i.toString() + '.jpeg'));
    }
  }
}
