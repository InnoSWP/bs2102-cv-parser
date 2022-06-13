import 'package:firebase_storage/firebase_storage.dart';

import 'package:cvparser/globals.dart' as globals;

import 'dart:developer' as devtools show log;

Future<void> deleteFolderContent() async {
  if (globals.sessionHashCode != null) {
    // handle user  inactive timeout
    await FirebaseStorage.instance
        .ref("uploads/${globals.sessionHashCode}/")
        .listAll()
        .then((value) {
      for (var element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
    devtools.log('Files in uploads/${globals.sessionHashCode} are deleted');
  }
}
