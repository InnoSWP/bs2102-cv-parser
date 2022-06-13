import 'package:cvparser/model/file_model.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;

class DroppedFileWidget extends StatelessWidget {
  final List<FileModel>? files;
  const DroppedFileWidget({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: buildFiles(context),
        ),
      ],
    );
  }

  Widget buildFiles(BuildContext context) {
    if (files == null) return buildEmptyFile('No Selected Files');

    return Column(
      children: <Widget>[
        for (var file in files!) buildFileDetail(file, context),
      ],
    );
  }

  Widget buildEmptyFile(String text) {
    return Container(
      width: 120,
      height: 120,
      color: Colors.blue.shade300,
      child: Center(child: Text(text)),
    );
  }

  Widget buildFileDetail(FileModel? file, BuildContext context) {
    const style = TextStyle(fontSize: 20);
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Selected File Preview ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          Text(
            'Name: ${file?.name}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Image.asset('images/pdf.png'),
            onTap: () async {
              var jsonFile = file!.text;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(jsonFile.toString()),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        //Code for download the image
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
