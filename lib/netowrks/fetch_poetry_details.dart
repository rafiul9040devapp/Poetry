import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poetry/utils/constants.dart';

import '../model/poetry_details.dart';

Future<PoetryDetails> getPoetryDetailsFromApi(
    http.Client client, String endPoint) async {
  final Uri uri = Uri.parse('$BASE_URL$TITLE_END_POINT$endPoint');

  try {
    final http.Response response = await http.get(uri);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return PoetryDetails.fromJson(responseBody);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw http.ClientException(
          '${responseBody['reason']} : ${responseBody['status']}');
    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      throw Exception('Server error occurred: ${response.statusCode}');
    } else {
      throw Exception('Failed to fetch poetry details: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch poetry details: $e');
  }
}
