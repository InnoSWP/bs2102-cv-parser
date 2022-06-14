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
  const DropZoneWidget({
    Key? key,
    // required this.onDroppedFile,
    required this.onProcessFiles,
  }) : super(key: key);

  // final ValueChanged<FileModel?> onDroppedFile;
  final ValueChanged<List<FileModel>?> onProcessFiles;

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
          // process dropping multiple files in the dropzone
          onDropMultiple: (List<dynamic>? ev) async {
            // do nothing if no files were returned
            if (ev?.isEmpty ?? false) return;
            // upload files to the database
            await deleteFirebaseFolderContent()
                .then((value) async => await uploadFiles(ev!));
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: MainColors.secondColor,
                      fixedSize: const Size(330.87, 83)),
                  onPressed: () async {
                    // Pick files using file explorer
                    await pickFilesOnPress().then((value) async {
                      await deleteFirebaseFolderContent();
                      return value;
                    }).then((value) async {
                      if (value == null) return;
                      await uploadFiles(value);
                    });
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

  Widget buildDecoration({required Widget child}) {
    final colorBackground =
        highlight ? MainColors.secondPageBackGround : Colors.white;
    return Container(
      color: colorBackground,
      child: DottedBorder(
        color: MainColors.secondColor,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        padding: EdgeInsets.zero,
        child: child,
      ),
    );
  }

  /// Function to pick files using local file explorer
  /// Allows to pick multiple files only of PDF type
  Future pickFilesOnPress() async {
    setState(() => highlight = true);
    return await controller.pickFiles(
      multiple: true,
      mime: ['application/pdf'],
    );
  }

  /// Function to upload multiple files to the Firebase
  /// [ev] argument is a list of files
  Future uploadFiles(List<dynamic> ev) async {
    // take time when files were uploaded to the Firebase
    // this time is used to create a folder with JSON files to be used
    DateTime timeUploaded = DateTime.now();
    globals.sessionHashCode = timeUploaded.hashCode;

    List<FileModel> droppedFiles = List<FileModel>.empty(growable: true);

    for (var event in ev) {
      try {
        // check if file has correct PDF extension
        if (await controller.getFileMIME(event) != 'application/pdf') {
          throw "Unexpected File Extension";
        }
      } catch (e) {
        // TODO process error
        devtools.log('Error occurred, only pdf files are allowed');
        setState(() => highlight = false);
        return;
      }

      String name = event.name;
      List<int> data = await controller.getFileData(event);

      late final String text;
      late final String jsonFile;

      try {
        //Load an existing PDF document.
        PdfDocument document = PdfDocument(inputBytes: data);
        //Create a new instance of the PdfTextExtractor.
        PdfTextExtractor extractor = PdfTextExtractor(document);
        //Extract all the text from the document.
        text = extractor.extractText();
      } catch (e) {
        // TODO process errors
        devtools.log('API error Unable to convert pdf to text');
        text = '';
        setState(() => highlight = false);
        return;
      }

      try {
        jsonFile = await retrieveJSON(
          text: text,
          keywords: "string",
          pattern: 11,
        );
      } catch (e) {
        devtools
            .log('Error with error code $e happened while sending API request');
        // TODO process errors
        // API errors are returned as integer number of server response
        setState(() => highlight = false);
        return;
      }

      // create fileModel from retrieved JSON
      FileModel file = FileModel(
        name: name,
        text: jsonFile.toString(),
        ext: 'json',
        hashFolder: timeUploaded.hashCode.toInt(),
      );

      try {
        // Upload file to the Firebase
        await FirebaseStorage.instance
            .ref('uploads/${file.hashFolder}/${file.name}.${file.ext}')
            .putString(file.text);
      } catch (e) {
        devtools.log('Error $e while saving files to the Firebase');
        // TODO process errors
        // process firebase errors
        setState(() => highlight = false);
        return;
      }

      droppedFiles.add(file);

      // widget.onDroppedFile(file);
    }
    // undo highlight to identify that files were uploaded
    setState(() => highlight = false);
    widget.onProcessFiles(droppedFiles);
    devtools.log('Successfully Saved All files to the database!');
  }
}
