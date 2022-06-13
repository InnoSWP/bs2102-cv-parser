import 'package:cvparser/model/match_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:developer' as devtools show log;

Future retrieveJSON(
    {required String text,
    required String keywords,
    required int pattern,
    required BuildContext context}) async {
  devtools.log("connect to internet");
  http.Response response = await http.post(
      Uri.parse('https://aqueous-anchorage-93443.herokuapp.com/CvParser'),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: jsonEncode({
        "text": text,
        "keywords": keywords,
        "pattern": pattern,
      }));
  devtools.log("connected");
  if (response.statusCode == 200) {
    // return json.decode(response.body);
    return response.body;
  }
  devtools.log("Error happened, error code: ${response.statusCode.toString()}");
  return response.statusCode;
}
