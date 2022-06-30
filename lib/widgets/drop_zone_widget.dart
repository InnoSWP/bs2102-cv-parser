import 'dart:developer' as devtools show log;
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../constants/colors.dart';
import '../model/custom_exceptions.dart';
import '../model/file_model.dart';
import '../utils/api_request.dart';
import '../utils/extract_from_pdf.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../main.dart';

class DropZoneWidget extends StatefulWidget {
  const DropZoneWidget({
    super.key,
    // required this.onDroppedFile,
    required this.onProcessFiles,
  });

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
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    return buildDecoration(
        child: Stack(
      children: <Widget>[
        DropzoneView(
          operation: DragOperation.copy,
          // cursor: CursorType.grab,
          onCreated: (DropzoneViewController controller) =>
              this.controller = controller,
          // process dropping multiple files in the dropzone
          onDropMultiple: (List<dynamic>? ev) async {
            if (ev?.isEmpty ?? false) return;
            EasyLoading.show(
              status: 'Uploading PDFs...',
              maskType: EasyLoadingMaskType.black,
            );
            uploadFiles(ev!);
          },
          onHover: () => setState(() {
            highlight = true;
          }),
          onLeave: () => setState(() => highlight = false),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                    await pickFilesOnPress().then((List<dynamic>! value) async {
                      if (value == null) {
                        return;
                      }
                      await uploadFiles(value);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
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
    final Color colorBackground =
        highlight ? MainColors.secondPageBackGround : Colors.white;
    return Container(
      color: colorBackground,
      child: DottedBorder(
        color: MainColors.secondColor,
        strokeWidth: 2,
        dashPattern: const <double>[8, 4],
        padding: EdgeInsets.zero,
        child: child,
      ),
    );
  }

  /// Function to pick files using local file explorer
  /// Allows to pick multiple files only of PDF type
  Future pickFilesOnPress() async {
    setState(() {
      EasyLoading.show(
        status: 'Uploading PDFs...',
        maskType: EasyLoadingMaskType.black,
      );
      highlight = true;
    });
    return await controller.pickFiles(

      multiple: true,
      mime: <String>['application/pdf'],
    );
  }

  /// Function to upload multiple files to the Firebase
  /// [ev] argument is a list of files
  Future uploadFiles(List<dynamic> ev) async {
    List<FileModel> droppedFiles = List<FileModel>.empty(growable: true);
    bool success = false;

    try {
      for (final dynamic event in ev) {
        // check if file has correct PDF extension
        if (await controller.getFileMIME(event) != 'application/pdf') {
          throw UnexpectedFileException(
              "Wrong extension, make sure you've all uploaded files in pdf format");
        }

        // get json file from pdf file
        final String jsonFile = await controller
            // retrieve data from pdf file
            .getFileData(event)
            // extract text from data retrieved
            .then((Uint8List value) => extractFromPdf(value))
            // get json file from pdf text
            .then((String value) async => retrieveJSON(
                  text: value,
                  keywords: 'string',
                  pattern: 11,
                ));

        // ignore: avoid_dynamic_calls
        final String name = event.name.toString();

        // create fileModel from retrieved JSON
        final FileModel file = FileModel(
          name: name,
          text: jsonFile,
          ext: '.json',
        );

        droppedFiles.add(file);
      }

      widget.onProcessFiles(droppedFiles);
    } on UnexpectedFileException catch (e) {
      success = true;
      EasyLoading.showError(
          'Wrong extension, make sure you\'ve all uploaded files in pdf format');
      devtools.log(e.toString());
    } on APIResponseException catch (e) {
      // TODO process errors
      if (!success) {
        success = true;
        EasyLoading.showError(
            'API error Unable to convert pdf to text. Error code - ${e.cause}');
      }
      devtools.log('API error Unable to convert pdf to text');
      devtools.log('Error code - ${e.cause}');
    } catch (e) {
      if (!success) {
        success = true;
        EasyLoading.showError(
          'Failed with Unexpected Error',
          //maskType: EasyLoadingMaskType.black,          to ask
        );
      }
      devtools.log('Unexpected error \'$e\' occurred');
    } finally {
      // undo highlight to identify that files were uploaded
      setState(() => {
            if (!success)
              {
                EasyLoading.showSuccess('PDFs are uploaded'),
                success = true,
              },
            highlight = false,
          });
    }
  }
}
