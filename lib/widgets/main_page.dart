import 'dart:convert';

import 'package:cvparser/model/file_model.dart';
import 'package:cvparser/utils/Search.dart';
import 'package:cvparser/widgets/file_download.dart';

import 'package:get/get.dart';

// ignore: for json download button
import 'package:firebase_storage/firebase_storage.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';

import '../part of UI/information_page.dart';
import '../part of UI/logo.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/*
  Main Page - page with all main functionality
 */

class MainPage extends StatefulWidget {
  static const String route = '/view_cv'; // todo

  final List<FileModel>? files; //PDF files from main page

  const MainPage({Key? key, required this.files}) : super(key: key);

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
        children: [
          // Left side of MainPage with text and button to download
          InformationWidget(jsonText: jsonText, jsonName: jsonName,),

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
        children: [
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
              fit: BoxFit.contain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
        if(jsonText.value == '') {
          showAlertDialog(context);
        }
        else{
          download(jsonText.value, downloadName: "${jsonName.value}.json");
        }
      },
      child: const Text(
        'Export as JSON',
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
            flex: 12,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'find a skill',
              ),
              onChanged: (String input){
                setState((){
                  currentFiles = search(widget.files, input);
                });
              },
            ),
          ),
          Flexible(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.none,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: MainColors.secondColor,
                    fixedSize: const Size(10, 50)),
                onPressed: () {},
                child: const Icon(Icons.search),
              ),
            )
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
              var jsonFileText = file.text;
              var jsonFileName = file.name;
              jsonText.value = jsonFileText.toString();
              jsonName.value = jsonFileName.toString();
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

  showAlertDialog(BuildContext context) {

    Widget closeButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: MainColors.secondColor),
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
    AlertDialog alert = AlertDialog(
      title: const Text("Error",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w100),),
      content: const Text("You do not choose the file to export",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w100),),
      actions: [
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
