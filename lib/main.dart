import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'widgets/home_page.dart';

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
      builder: EasyLoading.init(),
    ),
  );
}
