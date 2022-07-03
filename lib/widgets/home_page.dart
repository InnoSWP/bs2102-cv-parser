// ignore: unused_import
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../constants/colors.dart';
import '../model/file_model.dart';
import 'drop_zone_widget.dart';
import 'main_page.dart';

/*
  HomePage - First Page that user will see when he open the app
  It contains the drop zone for pdf, 'Parse CVs' button and App Bar with logo
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String route = '';

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  RxList<FileModel>? files = <FileModel>[
    FileModel(name: 'Mocasdsaddsadasdsak.pdf', text: '[{"label":"Skills","match":"Java","sentence":"I had an experience in Java"},{"label":"Language","match":"Eng","sentence":"B2 english"}]', ext: '.json'),
    FileModel(name: 'Mock2.pdf', text: '[{"label":"Skills","match":"C++","sentence":"I love C++"},{"label":"Skills","match":"Java","sentence":"I had an experience in Java"},{"label":"Language","match":"Eng","sentence":"B2 english"}]', ext: '.json'),
    FileModel(name: 'Mock3.pdf', text: '[{"label":"Skills","match":"C++","sentence":"I love C++"},{"label":"Language","match":"Eng","sentence":"B2 english"}]', ext: '.json'),
    FileModel(name: 'Mock4.pdf', text: 'JSON text4', ext: '.json'),
    FileModel(name: 'Mock5.pdf', text: 'JSON text5', ext: '.json'),
    FileModel(name: 'Mock6.pdf', text: 'JSON text5', ext: '.json'),
    FileModel(name: 'Mock7.pdf', text: 'JSON text5', ext: '.json'),
    FileModel(name: 'Mock8.pdf', text: 'JSON text5', ext: '.json'),
    FileModel(name: 'Mock9.pdf', text: 'JSON text5', ext: '.json'),
    FileModel(name: 'Mock10.pdf', text: 'JSON text5', ext: '.json'),
    FileModel(name: 'Mock11.pdf', text: 'JSON text5', ext: '.json'),
  ].obs; // For time, when API is not working

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.mainColor,
      appBar: buildAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              // Column for Drop zone and Button 'Parse CVs'
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Drop Zone
                  SizedBox(
                    height: 450,
                    width: 977,
                    child: DropZoneWidget(
                      // ignore: unnecessary_this
                      onProcessFiles: (List<FileModel>? files) =>
                          setState(() => this.files = RxList.from(files!)),
                    ),
                  ),
                  //Space between
                  const SizedBox(
                    height: 20,
                  ),
                  //Button Parse CVs
                  buildParseCVsButton(context),
                ],
              )),
        ),
      ),
    );
  }

  //AppBar
  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(101.0), // Size of appBar is 101
      child: AppBar(
        automaticallyImplyLeading:
            false, // Removing the 'back button' from navigator.pop()
        elevation: 0, // Remove shadow below the appBar
        backgroundColor: MainColors.mainColor,
        centerTitle: false, // Remove center alignment for appBar 'title'
        flexibleSpace: Container(
          margin: const EdgeInsets.only(left: 30.0),
          alignment: Alignment.bottomLeft,

          //Logo
          child: TextButton(
            child: const Text(
              'iExtract',
              style: TextStyle(
                  color: MainColors.secondColor,
                  fontFamily: 'Eczar',
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
  //Parse Cvs button

  ElevatedButton buildParseCVsButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MainColors.secondColor, fixedSize: const Size(330.87, 83)),
      onPressed: () {
        if (files?.length != null) {
          Navigator.of(context).push(MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => MainPage(files: files)));
        } else {
          showAlertDialog(context);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'PARSE CVs',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Eczar',
                fontSize: 30,
                fontWeight: FontWeight.w100),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.upload_file, size: 48),
        ],
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  final Widget closeButton = ElevatedButton(
    style: ElevatedButton.styleFrom(primary: MainColors.secondColor),
    child: const Text(
      'Close',
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Merriweather',
          fontSize: 16,
          fontWeight: FontWeight.w100),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  final AlertDialog alert = AlertDialog(
    title: const Text(
      'Error',
      style: TextStyle(
          color: Colors.black,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w100),
    ),
    content: const Text(
      'You have not uploaded any files',
      style: TextStyle(
          color: Colors.black,
          fontFamily: 'Merriweather',
          fontWeight: FontWeight.w100),
    ),
    actions: <Widget>[
      closeButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
