import 'package:cvparser/model/file_model.dart';
import 'package:cvparser/utils/api_request.dart';
import 'package:cvparser/utils/delete_folder_content.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:cvparser/constants/colors.dart';

import 'dart:developer' as devtools show log;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:cvparser/globals.dart' as globals;

class DropZoneWidget extends StatefulWidget {
  const DropZoneWidget({Key? key, required this.onDroppedFiles})
      : super(key: key);

  final ValueChanged<List<FileModel>?> onDroppedFiles;

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  late DropzoneViewController controller;
  bool highlight = false;

  @override
  void dispose() {
    deleteFolderContent();
    super.dispose();
    // TODO delete files after leaving the website
  }

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
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Merriweather',
                      fontSize: 26,
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                width: 203,
                height: 51,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // selectFiles();
                    final events = await controller
                        .pickFiles(multiple: true, mime: ['application/pdf']);
                    if (events.isEmpty) return;
                    uploadFiles(events);
                  },
                  label: const Text(
                    'UPLOAD PDFs',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Merriweather',
                        fontSize: 16),
                  ),
                  icon: const Icon(Icons.download_sharp),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    primary: highlight ? Colors.blue : MainColors.secondColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget buildDecoration({required Widget child}) {
    final colorBackground = highlight ? Colors.blue : Colors.white;
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

  Future uploadFiles(List<dynamic> ev) async {
    deleteFolderContent();
    DateTime timeUploaded = DateTime.now();
    globals.sessionHashCode = timeUploaded.hashCode;

    List<FileModel> droppedFiles = List<FileModel>.empty(growable: true);

    for (var event in ev) {
      var name = event.name;

      var mime = await controller.getFileMIME(event);
      if (mime != 'application/pdf') {
        throw "Unexpected File Extension";
      }

      devtools.log('File $name received');

      var data = await controller.getFileData(event);

      //Load an existing PDF document.
      PdfDocument document = PdfDocument(inputBytes: data);

      //Create a new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.
      String text = extractor.extractText();

      var jsonFile = await retrieveJSON(
        text: text,
        keywords: "string",
        pattern: 11,
        context: context,
      );

      FileModel file = FileModel(
        name: name,
        text: jsonFile.toString(),
        ext: 'json',
        hashFolder: timeUploaded.hashCode.toInt(),
      );
      // Upload file
      await FirebaseStorage.instance
          .ref('uploads/${file.hashFolder}/${file.name}.${file.ext}')
          .putString(file.text);

      droppedFiles.add(file);

      widget.onDroppedFiles(droppedFiles);
      setState(() {
        highlight = false;
      });
    }
    devtools.log('Successfully Saved to the database!');
  }
}
