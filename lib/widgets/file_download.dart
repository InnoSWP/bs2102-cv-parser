import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

void download(
  String context, {
  String downloadName = 'new_CV.json',
}) {
  final String base64 = base64Encode(context.codeUnits);
  final AnchorElement anchor =
      AnchorElement(href: 'data:application/octet-stream;base64,$base64')
        ..target = 'blank';
  anchor.download = downloadName;
  document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
