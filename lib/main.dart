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
      home: const FirstRoute(),
      routes: const {},
    ),
  );
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 253, 247, 1),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(127, 75, 36, 1),
              fixedSize: const Size(330.87, 83)
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Text('PARSE CVs', style: TextStyle(color: Colors.white, fontFamily: 'Eczar', fontSize: 26),),
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