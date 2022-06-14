import 'package:firebase_storage/firebase_storage.dart';

import 'package:cvparser/globals.dart' as globals;

import 'dart:developer' as devtools show log;

/// Function to delete all files from the current firebase uploads folder
Future<void> deleteFirebaseFolderContent() async {
  if (globals.sessionHashCode != null) {
    // handle user  inactive timeout
    await FirebaseStorage.instance
        .ref("uploads/${globals.sessionHashCode}/")
        .listAll()
        .then((value) {
      for (var element in value.items) {
        try {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        } catch (e) {
          // TODO fix this bug
          devtools.log(
              'Error while deleting files from folder (Apparently it does not exist)');
          break;
        }
      }
    });
    devtools.log('Files in uploads/${globals.sessionHashCode} are deleted');
  }
}
