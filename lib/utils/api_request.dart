import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/custom_exceptions.dart';

/// Sends API request to the server.
/// Sends [text, keywords, pattern] as request body parameters.
/// Contents of the JSON response is returned
/// If status code is different from 200, throws an error as a status code.
Future<String> retrieveJSON({
  required String text,
  required String keywords,
  required int pattern,
}) async {
  // Function to send an API request to the server
  final http.Response response = await http.post(
    // Uri.parse('https://aqueous-anchorage-93443.herokuapp.com/CvParser'),
    Uri.parse('https://mock-cv-parser-3.herokuapp.com/api/cv_parser/'),
    headers: <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, dynamic>{
      'text': text,
      'keywords': keywords,
      'pattern': pattern,
    }),
  );

  // returns JSON file if no error occurred
  if (response.statusCode == 200) {
    // return json.decode(response.body);
    return response.body;
  }
  // throw an error of the response code
  throw APIResponseException(response.statusCode.toString());
}
