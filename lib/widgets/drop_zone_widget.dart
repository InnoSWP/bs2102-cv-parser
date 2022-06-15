import 'package:cvparser/model/custom_exceptions.dart';
import 'package:cvparser/model/file_model.dart';
import 'package:cvparser/utils/api_request.dart';
import 'package:cvparser/utils/extract_from_pdf.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:cvparser/constants/colors.dart';

import 'dart:developer' as devtools show log;

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
            if (ev?.isEmpty ?? true) return;
            // upload files to the database
            await uploadFiles(ev!);
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
    List<FileModel> droppedFiles = List<FileModel>.empty(growable: true);

    try {
      for (var event in ev) {
        // check if file has correct PDF extension
        if (await controller.getFileMIME(event) != 'application/pdf') {
          throw UnexpectedFileException(
              'Wrong extension, make sure you\'ve all uploaded files in pdf format');
        }

        // get json file from pdf file
        String jsonFile = await controller
            // retrieve data from pdf file
            .getFileData(event)
            // extract text from data retrieved
            .then((value) => extractFromPdf(value))
            // get json file from pdf text
            .then((value) async => await retrieveJSON(
                  text: value,
                  keywords: "string",
                  pattern: 11,
                ));

        String name = event.name;

        // create fileModel from retrieved JSON
        FileModel file = FileModel(
          name: name,
          text: jsonFile.toString(),
          ext: '.json',
        );

        droppedFiles.add(file);
      }

      widget.onProcessFiles(droppedFiles);
    } on UnexpectedFileException catch (e) {
      devtools.log(e.toString());
    } on APIResponseException catch (e) {
      // TODO process errors
      devtools.log('API error Unable to convert pdf to text');
      devtools.log('Error code - ${e.cause}');
    } catch (e) {
      devtools.log('Unexpected error \'$e\' occurred');
    } finally {
      // undo highlight to identify that files were uploaded
      setState(() => highlight = false);
    }
  }
}
