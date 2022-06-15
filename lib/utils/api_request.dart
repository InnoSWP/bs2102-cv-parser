import 'dart:convert';

import 'package:http/http.dart' as http;

/// Sends API request to the server.
/// Sends [text, keywords, pattern] as request body parameters.
/// Contents of the JSON response is returned
/// If status code is different from 200, throws an error as a status code.
Future retrieveJSON({
  required String text,
  required String keywords,
  required int pattern,
}) async {
  // Function to send an API request to the server
  http.Response response = await http.post(
    Uri.parse('https://aqueous-anchorage-93443.herokuapp.com/CvParser'),
    //Uri.parse('https://mock-cv-parser-3.herokuapp.com/api/cv_parser/'),
    headers: {
      "accept": "application/json",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
    body: jsonEncode({
      "text": text,
      "keywords": keywords,
      "pattern": pattern,
    }),
  );

  // returns JSON file if no error occurred
  if (response.statusCode == 200) {
    // return json.decode(response.body);
    return response.body;
  }
  // devtools.log("Error happened, error code: ${response.statusCode.toString()}");

  // throw an error of the response code
  throw response.statusCode.toInt();
}
