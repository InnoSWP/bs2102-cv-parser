import 'package:cvparser/constants/test_variables.dart';
import 'package:cvparser/utils/api_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('API should return expected JSON', () async {
    final String jsonFile = await retrieveJSON(
      text: text,
      keywords: 'string',
      pattern: 11,
    );
    expect(jsonFile, response);
  });
}
