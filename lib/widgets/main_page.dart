import 'package:cvparser/model/file_model.dart';

import 'package:get/get.dart';

// ignore: for json download button
import 'package:firebase_storage/firebase_storage.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';

import '../part of UI/information_page.dart';
import '../part of UI/logo.dart';

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
  var jsonText = 'No Text'.obs; //Get_X pub dev for jsonText update

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.secondPageBackGround,
      appBar: buildAppBar(context),
      body: Row(
        children: [
          // Left side of MainPage with text and button to download
          InformationWidget(jsonText: jsonText),

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
          buildSearchField(),

          //PDF scroll list
          Container(
            alignment: Alignment.center,
            color: MainColors.mainColor,
            height: 400,
            width: 400,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: buildFiles(
                        context,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Download button
          buildDownloadButton()
        ],
      ),
    );
  }

  Row buildDownloadButton() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 36),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: MainColors.secondPageButtonColor,
                side: const BorderSide(color: MainColors.secondColor)),
            onPressed: () {
              //export json
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Export as JSON',
                  style: TextStyle(
                      color: MainColors.secondColor,
                      fontFamily: 'Eczar',
                      fontSize: 24,
                      fontWeight: FontWeight.w100),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 36),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: MainColors.secondPageButtonColor,
                side: const BorderSide(color: MainColors.secondColor)),
            onPressed: () {
              //export json
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Upload more CVs',
                  style: TextStyle(
                      color: MainColors.secondColor,
                      fontFamily: 'Eczar',
                      fontSize: 24,
                      fontWeight: FontWeight.w100),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            flex: 12,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'find a skill',
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: MainColors.secondColor,
                  fixedSize: const Size(10, 50)),
              onPressed: () {},
              child: const Icon(Icons
                  .search), //Const size, so when flex the window - icon stay constant
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
    return Column(
      children: <Widget>[
        if (widget.files != null)
          for (var file in widget.files!) buildFileDetail(file, context),
      ],
    );
  }

  Widget buildFileDetail(FileModel? file, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            child: Image.asset(
              'images/pdf.png',
              width: 50,
              height: 50,
            ),
            onTap: () async {
              var jsonFile = file!.text;
              jsonText.value = jsonFile.toString();
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
                fontSize: 18,
                fontWeight: FontWeight.w100),
          ),
        ],
      ),
    );
  }
}
