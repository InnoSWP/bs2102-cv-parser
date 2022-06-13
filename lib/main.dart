import 'package:cvparser/model/file_DataModel.dart';

import 'package:cvparser/widgets/drop_file_widget.dart';
import 'package:cvparser/widgets/drop_zone_widget.dart';
import 'package:cvparser/widgets/search_and_store_files.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/colors.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      title: 'CVp Parser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: const {},
    ),
  );
}
/*
  HomePage - First Page that user will see when he open the app
  It contains the drop zone for pdf, 'Parse CVs' button and App Bar with logo
 */

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<File_Data_Model>? files;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(101.0), // Size of appBar is 101
        child: AppBar(
          automaticallyImplyLeading: false,           // Removing the 'back button' from navigator.pop()
          elevation: 0,                               // Remove shadow below the appbar
          backgroundColor: MainColors.mainColor,
          centerTitle: false,                         // Remove center alignment for appbar 'title'
          flexibleSpace: Container(
            margin: const EdgeInsets.only(left: 30.0),
            alignment: Alignment.bottomLeft,
            /*
                                          iExtract logo
            I decide to use Text widget instead of Image due to Image bad quality and jpg format
             */
            child: const Text(
              'iExtract',
              style: TextStyle(
                  color: MainColors.secondColor,
                  fontFamily: 'Eczar',
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      backgroundColor: MainColors.mainColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(left: 30.0),
              // Column for Drop zone and Button 'Parse CVs'
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 506,
                    width: 1100,
                    child: DropZoneWidget(
                      // ignore: unnecessary_this
                      onDroppedFiles: (files) =>
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      );
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
                  SizedBox(
                    height: 40.0,
                  ),
                  DroppedFileWidget(files: files),
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
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            child: const Text(
              'iExtract',
              style: TextStyle(
                  color: MainColors.secondColor,
                  fontFamily: 'Eczar',
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
          ),
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
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              /*
            ----------------------------
            |                 |        |
            |                 |        |
            |                 |        |
            |                 |        |
            |                 |        |
            |                 |        |
            |                 |        |
            ----------------------------
              Row division
              */
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                /*
            ----------------------------
            |                 |        |
            |                 |        |
            |_________________|        |
            |                 |        |
            |                 |        |
            |_________________|        |
            |                 |        |
            ----------------------------
                 */
                ),
              const SearchAndStoreFiles(), // For right side (not completed)
              ],
            )),
      ),
    );
  }
}
