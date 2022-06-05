import 'package:cvparser/model/file_DataModel.dart';
import 'package:cvparser/widgets/drop_file_widget.dart';
import 'package:cvparser/widgets/drop_zone_widget.dart';
import 'package:firebase_core/firebase_core.dart';
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
      body: SingleChildScrollView(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: DropZoneWidget(
                    // ignore: unnecessary_this
                    onDroppedFiles: (files) =>
                        setState(() => this.files = files),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DroppedFileWidget(files: files),
              ],
            )),
      ),
    );
  }
}
