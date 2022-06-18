import 'package:cvparser/model/file_model.dart';
import 'package:cvparser/widgets/drop_zone_widget.dart';
import 'package:get/get.dart';

// ignore: for json download button
import 'package:firebase_storage/firebase_storage.dart';

import 'constants/colors.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'dart:developer' as devtools show log;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() async {
  // allow widgets interaction with the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // connect to Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    MaterialApp(
      title: 'CV Parser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

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
  List<FileModel>? files;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(101.0), // Size of appBar is 101
        child: AppBar(
          automaticallyImplyLeading: false,
          // Removing the 'back button' from navigator.pop()
          elevation: 0,
          // Remove shadow below the appbar
          backgroundColor: MainColors.mainColor,
          centerTitle: false,
          // Remove center alignment for appbar 'title'
          flexibleSpace: Container(
              margin: const EdgeInsets.only(left: 30.0),
              alignment: Alignment.bottomLeft,
              /*
                                          iExtract logo
            I decide to use Text widget instead of Image due to Image bad quality and jpg format
             */
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
              )),
        ),
      ),
      backgroundColor: MainColors.mainColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              // Column for Drop zone and Button 'Parse CVs'
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 506,
                    width: 1100,
                    child: DropZoneWidget(
                      // ignore: unnecessary_this
                      onProcessFiles: (files) =>
                          setState(() => this.files = files),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MainColors.secondColor,
                        fixedSize: const Size(330.87, 83)),
                    // Button 'Parse CVs' will send you to Main Page
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MainPage(files: files)));
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
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

/*
  Main Page - page with all main functionality
 */

class MainPage extends StatefulWidget {
  static const String route = '/view_cv';
  final List<FileModel>? files;

  const MainPage({Key? key, required this.files}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var jsonText = 'No Text'.obs;

  Widget buildFiles(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.files != null)
          for (var file in widget.files!) buildFileDetail(file, context),
      ],
    );
  }

  Widget buildFileDetail(FileModel? file, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            child: Image.asset(
              'images/pdf.png',
              width: 50,
              height: 50,
            ),
            onTap: () async {
              var jsonFile = file!.text;
              jsonText.value = jsonFile.toString();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            ' ${file?.name ?? 'No name'}',
            style: const TextStyle(
                color: MainColors.secondColor,
                fontFamily: 'Merriweather',
                fontSize: 18,
                fontWeight: FontWeight.w100),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The same App Bar as it is in Home Page, but with line below it
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(101.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: MainColors.mainColor,
          centerTitle: false,
          flexibleSpace: Container(
              margin: const EdgeInsets.only(left: 30.0),
              alignment: Alignment.topLeft,
              child: TextButton(
                child: const Text(
                  'iExtract',
                  style: TextStyle(
                      color: MainColors.secondColor,
                      fontFamily: 'Eczar',
                      fontSize: 60,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          // second Color border line at the bottom of App Bar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: MainColors.secondColor,
              height: 2.0,
            ),
          ),
        ),
      ),

      backgroundColor: MainColors.secondPageBackGround,

      body: Row(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: MainColors.secondColor,
                    width: 3.0,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Flexible(
                    flex: 5,
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Text(
                                jsonText.value,
                                style: const TextStyle(
                                    color: MainColors.secondColor,
                                    fontFamily: 'Merriweather',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w100),
                              ),
                            )), // Json text
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: MainColors.secondPageButtonColor,
                          fixedSize: const Size(453, 108),
                          side:
                              const BorderSide(color: MainColors.secondColor)),
                      // Button 'Parse CVs' will send you to Main Page
                      onPressed: () {
                        //export json
                      },
                      // 'Parse CVs' button with icon itself
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 207,
                            child: Text(
                              'Export as JSON',
                              style: TextStyle(
                                  color: MainColors.secondColor,
                                  fontFamily: 'Eczar',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w100),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.download_sharp,
                            size: 80,
                            color: MainColors.secondColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        flex: 12,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'find a skill',
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: MainColors.secondColor,
                              fixedSize: const Size(10, 50)),
                          onPressed: () {},
                          child: const Icon(Icons
                              .search), //Const size, so when flex the window - icon stay constant
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  color: MainColors.mainColor,
                  height: 400,
                  width: 400,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: buildFiles(
                              context,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 36),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: MainColors.secondPageButtonColor,
                        fixedSize: const Size(278, 62),
                        side: const BorderSide(color: MainColors.secondColor)),
                    // Button 'Parse CVs' will send you to Main Page
                    onPressed: () {
                      //export json
                    },
                    // 'Parse CVs' button with icon itself
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Export as JSON',
                          style: TextStyle(
                              color: MainColors.secondColor,
                              fontFamily: 'Eczar',
                              fontSize: 24,
                              fontWeight: FontWeight.w100),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
