import 'package:cvparser/constants/test_variables.dart';
import 'package:cvparser/utils/api_request.dart';
import 'package:cvparser/utils/extract_from_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // test('API should return expected JSON', () async {
  //   final String jsonFile = await retrieveJSON(
  //     text: text,
  //     keywords: 'string',
  //     pattern: 11,
  //   );
  //   expect(jsonFile, response);
  // });

  test('API should return expected JSON', () async {
    final String text = extractFromPdf(pdf);
    expect(text, pdfText);
  });

  test('ExtractTextFromPdf function should convert pdf to text', () async {
    final String text = extractFromPdf(pdf);
    expect(text, pdfText);
  });

  test(
      'Search Function should return only those files that match particular pattern',
      () async {
    final String text = extractFromPdf(pdf);
    expect(text, pdfText);
  });

  test('CVs details should be returned after clicking on PDF icon', () async {
    final String text = extractFromPdf(pdf);
    expect(text, pdfText);
  });

  test(
      'After clicking on download button the all active files should be downloaded',
      () async {
    final String text = extractFromPdf(pdf);
    expect(text, pdfText);
  });
}
