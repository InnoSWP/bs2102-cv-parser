import 'dart:convert';
import 'dart:html';

void download(
    String context, {
      String downloadName = 'new_CV.json',
    }) {

  final _base64 = base64Encode(context.codeUnits);
  final anchor =
  AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
    ..target = 'blank';
  anchor.download = downloadName;
  document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}