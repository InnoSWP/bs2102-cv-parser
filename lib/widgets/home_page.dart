import 'package:cvparser/model/file_model.dart';
import 'package:cvparser/part%20of%20UI/logo.dart';
import 'package:cvparser/widgets/drop_zone_widget.dart';
import 'package:cvparser/widgets/main_page.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'dart:developer' as devtools show log;

/*
  HomePage - First Page that user will see when he open the app
  It contains the drop zone for pdf, 'Parse CVs' button and App Bar with logo
 */
class HomePage extends StatefulWidget {
  static const String route = '';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<FileModel>? files = [
    FileModel(name: 'Mock.pdf', text: 'JSON text', ext: '.json'),
    FileModel(name: 'Mock2.pdf', text: 'JSON text2', ext: '.json'),
    FileModel(name: 'Mock3.pdf', text: 'JSON text3', ext: '.json'),
    FileModel(name: 'Mock4.pdf', text: 'JSON text4', ext: '.json'),
    FileModel(name: 'Mock5.pdf', text: 'JSON text5', ext: '.json'),
  ]; // For time, when API is not working

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
                children: [
                  //Drop Zone
                  SizedBox(
                    height: 506,
                    width: 1100,
                    child: DropZoneWidget(
                      // ignore: unnecessary_this
                      onProcessFiles: (files) =>
                          setState(() => this.files = files),
                    ),
                  ),

                  //Space between
                  const SizedBox(
                    height: 40,
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
        automaticallyImplyLeading: false, // Removing the 'back button' from navigator.pop()
        elevation: 0, // Remove shadow below the appbar
        backgroundColor: MainColors.mainColor,
        centerTitle: false, // Remove center alignment for appbar 'title'
        flexibleSpace: Container(
            margin: const EdgeInsets.only(left: 30.0),
            alignment: Alignment.bottomLeft,

            //Logo
            child: const IExtractLogo()),
      ),
    );
  }
  //Parse Cvs button

  ElevatedButton buildParseCVsButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MainColors.secondColor, fixedSize: const Size(330.87, 83)),
      // Button 'Parse CVs' will send you to Main Page
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MainPage(files: files)));
      },
      // 'Parse CVs' button with icon itself
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
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