import 'package:cvparser/model/file_DataModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:developer' as devtools show log;

class DroppedFileWidget extends StatelessWidget {
  final List<File_Data_Model>? files;
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

  // Widget buildFile(BuildContext context) {
  //   if (file == null) return buildEmptyFile('No Selected File');

  //   // devtools.log(file!.url.toString());

  //   return Column(
  //     children: [
  //       if (file != null) buildFileDetail(file),
  //     ],
  //   );
  // }

  Widget buildEmptyFile(String text) {
    return Container(
      width: 120,
      height: 120,
      color: Colors.blue.shade300,
      child: Center(child: Text(text)),
    );
  }

  Widget buildFileDetail(File_Data_Model? file, BuildContext context) {
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
              var jsonFile = await retrieveJSON(
                  text: file!.text,
                  keywords: "string",
                  pattern: 11,
                  context: context);
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

Future retrieveJSON(
    {required String text,
    required String keywords,
    required int pattern,
    required BuildContext context}) async {
  devtools.log("connect to internet");
  text = "Anvar Iskhakov, Innopolis University";
  http.Response response = await http.post(
      Uri.parse('https://aqueous-anchorage-93443.herokuapp.com/CvParser'),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "text": text,
        "keywords": keywords,
        "pattern": pattern,
      }));
  devtools.log("connected");
  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  devtools.log("Error happened");
  return null;
}

Future<List<Match>> retrieveCV(
    {required String text,
    required String keywords,
    required int pattern,
    required BuildContext context}) async {
  List<Match> matchList = [];
  devtools.log("connect to internet");
  http.Response response = await http.post(
      Uri.parse('https://aqueous-anchorage-93443.herokuapp.com/CvParser'),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "text": text,
        "keywords": keywords,
        "pattern": pattern,
      }));
  if (response.statusCode == 200) {
    final body = json.decode(response.body) as List;
    for (var json in body) {
      devtools.log(json);
      matchList.add(Match.fromJson(json));
    }
    return matchList;
  }
  return [];
}

class Match {
  final String match;
  final String label;
  final String sentence;

  const Match(
      {required this.match, required this.label, required this.sentence});

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      match: json['match'],
      label: json['label'],
      sentence: json['sentence'],
    );
  }

  // Match.fromJson(Map<String, dynamic> json) {
  //   match = json['match'];
  //   label = json['label'];
  //   sentence = json['sentence'];
  // }
}
