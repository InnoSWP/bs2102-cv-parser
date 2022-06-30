import 'dart:convert';

import 'package:cvparser/model/file_model.dart';
import 'package:cvparser/utils/Search.dart';
import 'package:cvparser/widgets/file_download.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../model/file_model.dart';
import '../part of UI/information_page.dart';
import '../part of UI/logo.dart';
import 'file_download.dart';

/*
  Main Page - page with all main functionality
 */

class MainPage extends StatefulWidget {
  //PDF files from main page

  const MainPage({super.key, required this.files});
  static const String route = '/view_cv'; // todo

  final List<FileModel>? files;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<FileModel>? currentFiles;

  var jsonText = ''.obs; //Get_X pub dev for jsonText update
  var jsonName = ''.obs;

  late FileModel activeFile;

  @override
  void initState() {
    currentFiles = widget.files;
    if (widget.files != null) activeFile = widget.files!.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.secondPageBackGround,
      appBar: buildAppBar(context),
      body: Row(
        children: <Widget>[
          // Left side of MainPage with text and button to download
          InformationWidget(
            jsonText: jsonText,
            jsonName: jsonName,
          ),

          // Right side of MainPage with search and PDF scroll and 2 buttons
          buildPDFScroll(context),
        ],
      ),
    );
  }

  Flexible buildPDFScroll(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Search field and search button
          Expanded(
            flex: 2,
            child: buildSearchField(),
          ),
          //PDF scroll list
          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.centerLeft,
              color: MainColors.mainColor,
              child: buildFiles(context),
            ),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildDownloadButton(),
                  buildUploadMoreButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildDownloadButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MainColors.secondPageButtonColor,
          side: const BorderSide(color: MainColors.secondColor)),
      onPressed: () {
        if(currentFiles!.isEmpty) {
          showAlertDialog(context);
        }
        else{
          int? size = currentFiles?.length;
          for(int i = 0; i < size!; i++) {
            var text;
            var name;
            if(currentFiles![i].text != null && currentFiles![i].name != null){
              text = currentFiles![i].text;
              name = currentFiles![i].name;
            }
            download(text, downloadName: "$name.json");
          }
        }
      },
      child: const Text(
        'Export all JSONs',
        style: TextStyle(
            color: MainColors.secondColor,
            fontFamily: 'Eczar',
            fontSize: 24,
            fontWeight: FontWeight.w100),
      ),
    );
  }

  ElevatedButton buildUploadMoreButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MainColors.secondPageButtonColor,
          side: const BorderSide(color: MainColors.secondColor)),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        'Upload more CVs',
        style: TextStyle(
            color: MainColors.secondColor,
            fontFamily: 'Eczar',
            fontSize: 24,
            fontWeight: FontWeight.w100),
      ),
    );
  }

  Padding buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
        children: <Widget>[
          const Flexible(
            flex: 12,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'find a skill',
              ),
              onChanged: (String input){
                setState((){
                  if(input == ""){
                    currentFiles = widget.files;
                  }
                  else {
                    currentFiles = search(widget.files, input);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // The same App Bar as it is in Home Page, but with line below it

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(101.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: MainColors.mainColor,
        centerTitle: false,
        flexibleSpace: Container(
            margin: const EdgeInsets.only(left: 30.0),
            alignment: Alignment.topLeft,
            child: const IExtractLogo()),
        // second Color border line at the bottom of App Bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: MainColors.secondColor,
            height: 2.0,
          ),
        ),
      ),
    );
  }

  Widget buildFiles(BuildContext context) {
    return GridView.count(
      primary: false,
      crossAxisCount: 3,
      children: <Widget>[
        if (currentFiles != null)
          for (var file in currentFiles!) buildFileDetail(file, context),
      ],
    );
  }

  Widget buildFileDetail(FileModel? file, BuildContext context) {
    return FittedBox(
      fit: BoxFit.none,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Image.asset(
              'images/pdf.png',
              width: 70,
              height: 70,
            ),
            onTap: () async {
              activeFile = file!;
              final String jsonFileText = file.text;
              final String jsonFileName = file.name;
              jsonText.value = jsonFileText;
              jsonName.value = jsonFileName;
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
                fontSize: 22,
                fontWeight: FontWeight.w100),
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    final Widget closeButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: MainColors.secondColor),
      child: const Text(
        'Close',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather',
            fontSize: 16,
            fontWeight: FontWeight.w100),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    final AlertDialog alert = AlertDialog(
      title: const Text(
        'Error',
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w100),
      ),
      content: const Text(
        'You do not choose the file to export',
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w100),
      ),
      actions: <Widget>[
        closeButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
