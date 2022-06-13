import 'dart:typed_data';

import 'package:cvparser/model/file_DataModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:cvparser/constants/colors.dart';

import 'dart:developer' as devtools show log;

import 'package:syncfusion_flutter_pdf/pdf.dart';

class DropZoneWidget extends StatefulWidget {
  const DropZoneWidget({Key? key, required this.onDroppedFiles})
      : super(key: key);

  final ValueChanged<List<File_Data_Model>?> onDroppedFiles;

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  late DropzoneViewController controller;
  bool highlight = false;

  @override
  Widget build(BuildContext context) {
    return buildDecoration(
        child: Stack(
      children: [
        DropzoneView(
          operation: DragOperation.copy,
          // cursor: CursorType.grab,
          onCreated: (controller) => this.controller = controller,
          // onDrop: uploadedFiles,
          onDropMultiple: (List<dynamic>? ev) async {
            devtools.log('Scanned Successfully!');
            if (ev?.isEmpty ?? false) return;
            devtools.log('$ev.runtimeType');
            uploadFiles(ev!);
          },
          onHover: () => setState(() => highlight = true),
          onLeave: () => setState(() => highlight = false),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 450,
                height: 86,
                child: Text(
                  'Drag and drop your PDF files here or',
                  style: TextStyle(color: Colors.black, fontFamily: 'Merriweather', fontSize: 26, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                width: 203,
                height: 51,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: MainColors.secondColor,
                      fixedSize: const Size(330.87, 83)),
                  onPressed: () async {
                    // selectFiles();
                    final events = await controller
                        .pickFiles(multiple: true, mime: ['application/pdf']);
                    if (events.isEmpty) return;
                    uploadFiles(events);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'UPLOAD PDFs',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather',
                            fontSize: 16,
                            ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.download_sharp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Future uploadFiles(List<dynamic> ev) async {
    List<File_Data_Model> droppedFiles =
        List<File_Data_Model>.empty(growable: true);

    for (var event in ev) {
      devtools.log('$event.runtimeType');
      var name = event.name;
      devtools.log('$event.name');

      var mime = await controller.getFileMIME(event);
      if (mime != 'application/pdf') {
        throw "Unexpected File Extension";
      }
      var byte = await controller.getFileSize(event);
      var url = await controller.createFileUrl(event);

      var data = await controller.getFileData(event);

      Uint8List fileBytes = await controller.getFileData(event);
      String fileName = name;

      // Upload file
      await FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putData(fileBytes);

      //Load an existing PDF document.
      PdfDocument document = PdfDocument(inputBytes: data);

      //Create a new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.
      String text = extractor.extractText();

      devtools.log('Name : $name');
      devtools.log('Text : $text');

      devtools.log('Mime: $mime');

      devtools.log('Size : ${byte / (1024 * 1024)}');
      devtools.log('URL: $url');
      devtools.log('Data: $data');

      droppedFiles.add(File_Data_Model(name: name, text: text));

      widget.onDroppedFiles(droppedFiles);
      setState(() {
        highlight = false;
      });
    }
  }

  Widget buildDecoration({required Widget child}) {
    final colorBackground = highlight ? MainColors.secondPageBackGround : Colors.white;
    return Container(
      color: colorBackground,
      child: DottedBorder(
          color: MainColors.secondColor,
          strokeWidth: 2,
          dashPattern: const [8, 4],
          padding: EdgeInsets.zero,
          child: child),
    );
  }
}
