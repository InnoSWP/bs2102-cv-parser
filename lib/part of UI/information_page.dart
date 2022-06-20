import 'package:get/get.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    Key? key,
    required this.jsonText,
  }) : super(key: key);

  final RxString jsonText;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 4,
      // For Border Line
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: MainColors.secondColor,
              width: 3.0,
            ),
          ),
        ),
        child: Column(
          children: [
            buildTextSpace(),
            buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Flexible buildDownloadButton() {
    return Flexible(
      flex: 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: MainColors.secondPageButtonColor,
            fixedSize: const Size(453, 108),
            side: const BorderSide(color: MainColors.secondColor)),
        // Button 'Parse CVs' will send you to Main Page
        onPressed: () {
          // todo export json
        },

        // 'Parse CVs' button with icon itself
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              width: 207,
              child: Text(
                'Export as JSON',
                style: TextStyle(
                    color: MainColors.secondColor,
                    fontFamily: 'Eczar',
                    fontSize: 32,
                    fontWeight: FontWeight.w100),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.download_sharp,
              size: 80,
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
}
