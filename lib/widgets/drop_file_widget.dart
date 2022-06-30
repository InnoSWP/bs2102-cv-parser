import 'dart:convert';
// ignore: unused_import
import 'dart:developer' as devtools show log;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../model/file_model.dart';

class DroppedFileWidget extends StatelessWidget {
  const DroppedFileWidget({super.key, required this.files});
  final List<FileModel>? files;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: buildFiles(context),
        ),
      ],
    );
  }

  Widget buildFiles(BuildContext context) {
    if (files == null) {
      return buildEmptyFile('No Selected Files');
    }

    return Column(
      children: <Widget>[
        if (files != null)
          for (FileModel file in files!) buildFileDetail(file, context),
      ],
    );
  }

  Widget buildEmptyFile(String text) {
    return Container(
      width: 300,
      height: 400,
      color: MainColors.mainColor,
      child: Center(child: Text(text)),
    );
  }

  Widget buildFileDetail(FileModel? file, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: Column(
        children: <Widget>[
          const Text(
            'Selected File Preview ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          Text(
            'Name: ${file?.name ?? 'No name'}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Image.asset('images/pdf.png'),
            onTap: () {
              final String jsonFile = file!.text;
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(jsonFile),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Download'),
                      onPressed: () {
                        // prepare
                        final List<int> bytes = utf8.encode(file.text);
                        final html.Blob blob = html.Blob(<List<int>>[bytes]);
                        final String url =
                            html.Url.createObjectUrlFromBlob(blob);
                        final html.AnchorElement anchor = html.document
                            .createElement('a') as html.AnchorElement
                          // ignore: unsafe_html
                          ..href = url
                          ..style.display = 'none'
                          ..download = '${file.name}${file.ext}';
                        html.document.body?.children.add(anchor);

                        // download
                        anchor.click();

                        // cleanup
                        html.document.body?.children.remove(anchor);
                        html.Url.revokeObjectUrl(url);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
