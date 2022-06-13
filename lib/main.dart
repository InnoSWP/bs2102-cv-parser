import 'package:cvparser/model/file_model.dart';
import 'package:cvparser/utils/delete_folder_content.dart';
//import 'package:cvparser/widgets/drop_file_widget.dart'; When page2 is completed
import 'package:cvparser/widgets/drop_zone_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/colors.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  html.window.onBeforeUnload.listen((event) async {
    deleteFolderContent();
  });

  runApp(
    MaterialApp(
      title: 'CV Parser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: const {},
    ),
  );
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.mainColor,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: MainColors.secondColor,
              fixedSize: const Size(330.87, 83)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Text(
            'PARSE CVs',
            style: TextStyle(
                color: Colors.white, fontFamily: 'Eczar', fontSize: 26),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<FileModel>? files;

  @override
  void dispose() {
    devtools.log('disposed');
    deleteFolderContent();
    super.dispose();
    // TODO delete files after leaving the website
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        devtools.log('willPopScope');
        deleteFolderContent();
        return true;
      }),
      child: Scaffold(
        backgroundColor: MainColors.mainColor,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'iExtract',
                      style: TextStyle(
                          color: MainColors.secondColor,
                          fontFamily: 'Eczar',
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 570,
                    width: 1240,
                    child: DropZoneWidget(
                      // ignore: unnecessary_this
                      onDroppedFiles: (files) =>
                          setState(() => this.files = files),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MainColors.secondColor,
                        fixedSize: const Size(330.87, 83)),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const HomePage()),
                      // );
                      // When page2 is created it is the route
                    },
                    child: const Text(
                      'PARSE CVs',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Eczar',
                          fontSize: 26,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
