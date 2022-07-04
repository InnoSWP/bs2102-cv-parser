import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../widgets/file_download.dart';
import 'dart:convert';
import '../widgets/main_page.dart';

List<String> tags = ['Skills', 'Language'];

//Set<String> tags1 = {'Skills','Language'};
class Item {
  late String groupName;
  late String content;

  Item({required String serialized}) {
    print(serialized);
    groupName = serialized.substring(9, serialized.indexOf('","match":"'));
    content = serialized.substring(serialized.indexOf('","match":"') + 11,
        serialized.indexOf('","sentence":'));
  }
}

class Group {
  Group({
    //required this.id,
    required this.name,
    required this.description,
    required this.children,
    this.isExpanded = false,
  });

  //int id;
  String name;
  String description;
  bool isExpanded;
  List<String> children;
}

class DropDownList extends StatefulWidget {
  const DropDownList({
    super.key,
    required this.jsonText,
    required this.jsonName,
  });

  final RxString jsonText;
  final RxString jsonName;

  @override
  State<DropDownList> createState() =>
      _DropDownListState(jsonText: jsonText, jsonName: jsonName);
}

class _DropDownListState extends State<DropDownList> {
  final RxString jsonText;
  final RxString jsonName;
  var isPressed = false.obs;

  _DropDownListState({
    required this.jsonText,
    required this.jsonName,
  });

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  List<Group> _generateItems(String? json) {
    if (json == null || json.isEmpty) return [];
    json = json
        .replaceRange(json.length - 2, json.length, "")
        .replaceRange(0, 2, "");
    List<Item> microItems = [];
    List<String> serialized = json.split('},{');
    for (final s in serialized) {
      microItems.add(Item(serialized: s));
    }
    List<Group> r = [];
    for (final mi in microItems) {
      Group? group;
      for (final i in r) {
        if (i.name == mi.groupName) {
          group = i;
        }
      }
      if (group == null) {
        r.add(
            Group(name: mi.groupName, description: "", children: [mi.content]));
      } else {
        group.children.add(mi.content);
      }
    }
    return r;
    // String json = jsonText.value;
    // List <Item> items = [];
    // while (json.length > 2){
    //   int t = json.indexOf('}');
    //   String str = json.substring(1,t + 1);
    //   for (final element in tags){
    //     if(str.contains(element)){
    //       for(final element1 in items){
    //         if (element == element1){
    //           element1.children.add(str.substring(str.indexOf('match:') + 7, str.indexOf('sentence:') - 3));
    //         }
    //       }
    //       List <String> children1 = [str.substring(str.indexOf('match:') + 9, str.indexOf('sentence:') - 3)];
    //       items.add(Item(name: element, description: element, children: children1));
    //     }
    //   }
    //   json = json.substring(t + 1);
    // }
    // print(items.length);
    // //return items;
    // return [Item(name: 'aboba', description: 'description', children: ['asas','sadad'])];
  }

  @override
  Widget build(BuildContext context) {
    //MainAxisAlignment: MainAxisAlignment.start;
    List<Group> items = _generateItems(jsonText.value);
    List<Widget> columnChildren = [
      Obx(() => isPressed.value
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 40,
                    color: MainColors.secondColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        jsonName.value,
                        style: TextStyle(
                            color: MainColors.secondColor,
                            fontFamily: 'Eczar',
                            fontSize: 20,
                            fontWeight: FontWeight.w100),
                      ),
                      Text(
                        "emailaddress@gmail.com",
                        style: TextStyle(
                            color: MainColors.secondColor,
                            fontFamily: 'Eczar',
                            fontSize: 16,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(
                  left: 50, right: 50, top: 10, bottom: 10),
              child: buildDownloadButton(context),
            ),
          ),
        ],
      )
          : Container())
    ];

    for (final group in items) {
      isPressed.value = true;

      columnChildren.add(ExpansionTile(
          title: Text(
            group.name,
            style: TextStyle(
                color: MainColors.secondColor,
                fontFamily: 'Eczar',
                fontSize: 32,
                fontWeight: FontWeight.w100),
          ),
          tilePadding: EdgeInsets.all(3.0),
          //collapsedTextColor: Colors.black,
          //textColor: Colors.black,
          children: group.children
              .map<Widget>((String s) => Container(
                  child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child:ListTile(
              title:Text(s, style: TextStyle(
                    color: MainColors.secondColor,
                    fontFamily: 'Eczar',
                    fontSize: 26,
                    fontWeight: FontWeight.w100),
          ),
                trailing: IconButton(
              hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: (){
                  
                  setState(() {
                    
                  });
                },
                icon: Icon(Icons.restore_from_trash_sharp),
            ),
            )
                      )
                      ))
              .toList()));
    }
    return Flexible(
      flex: 4,
      // For Border Line
      child: Container(
        child: SingleChildScrollView(
            child: Column(children: columnChildren
                // [
                //   //buildDownloadButton(context),
                //   Text(jsonText.toString()),
                //   Text(jsonName.toString()),
                //   //ignore: avoid_dynamic_calls
                //   //Text(items.toString()),

                //   ExpansionPanelList(
                //     animationDuration: const Duration(milliseconds: 350),
                //     expandedHeaderPadding: EdgeInsets.all(10),
                //     dividerColor: Colors.red,
                //     elevation: 4,
                //     expansionCallback: (int index, bool isExpanded) {
                //       setState(() {
                //         items[index].isExpanded = !isExpanded;
                //       });
                //     },
                //     children: items.map((item) => _buildExpansionPanel(item))
                //         .toList(),
                //   )
                //   ],
                )),
        /*
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildTextSpace(),
            buildDownloadButton(context),

          /*
            const SizedBox(
              height: 10,
            ) */
          ],
        ),
        */
      ),
    );
  }

  Widget buildDownloadButton(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: MainColors.secondPageButtonColor,
            fixedSize: const Size(350, 80),
            side: const BorderSide(color: MainColors.secondColor)),
        // Button 'Parse CVs' will send you to Main Page
        onPressed: () {
          if (jsonText.value == '') {
            showAlertDialog(context);
          } else {
            download(jsonText.value, downloadName: '${jsonName.value}.json');
          }
        },

        // 'Parse CVs' button with icon itself
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SizedBox(
              width: 207,
              child: Text(
                'Export as JSON',
                style: TextStyle(
                    color: MainColors.secondColor,
                    fontFamily: 'Eczar',
                    fontSize: 28,
                    fontWeight: FontWeight.w100),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.download_sharp,
              size: 65,
              color: MainColors.secondColor,
            ),
          ],
        ),
      ),
    );
  }

  Flexible buildTextSpace() {
    return Flexible(
      flex: 5,
      child: ListView(
        primary: true,
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  jsonText.value,
                  style: const TextStyle(
                      color: MainColors.secondColor,
                      fontFamily: 'Merriweather',
                      fontSize: 18,
                      fontWeight: FontWeight.w100),
                ),
              )), // Json text
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
