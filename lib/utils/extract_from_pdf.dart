import 'package:syncfusion_flutter_pdf/pdf.dart';

String extractFromPdf(List<int> data) {
  //Load an existing PDF document.
  final PdfDocument document = PdfDocument(inputBytes: data);
  //Create a new instance of the PdfTextExtractor.
  final PdfTextExtractor extractor = PdfTextExtractor(document);
  //Extract all the text from the document.
  return extractor.extractText();
}
