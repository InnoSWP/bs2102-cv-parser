import 'package:flutter/material.dart';

import '../constants/colors.dart';

/*
                                 iExtractLogo
I made it text as the picture was of poor quality and had extra edges with the background
 */

class IExtractLogo extends StatelessWidget {
  const IExtractLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'iExtract',
        style: TextStyle(
            color: MainColors.secondColor,
            fontFamily: 'Eczar',
            fontSize: 60,
            fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
