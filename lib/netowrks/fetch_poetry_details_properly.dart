import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/poetry_details.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';

Future<PoetryDetails> getPoetryDetails(http.Client client, String endPoint) async {
  final Uri uri = Uri.parse('$baseUrl$title/${customEncode(endPoint)}');

  try {
    final http.Response response = await client.get(uri);
    final String utfResponseBody = utf8.decode(response.bodyBytes);
    final dynamic responseBody = jsonDecode(utfResponseBody);

    if (response.statusCode == 200) {
      if (responseBody is List && responseBody.isNotEmpty) {
        return PoetryDetails.fromJson(responseBody[0] as Map<String, dynamic>);
      } else {
        throw Exception('Invalid response format: Expected List<dynamic> with at least one item');
      }
    } else {
      _handleError(response.statusCode);
    }
  } catch (e) {
    throw Exception('Failed to fetch poetry details: $e');
  }

  throw Exception('Failed to fetch poetry details');
}

void _handleError(int statusCode) {
  if (statusCode >= 400 && statusCode < 500) {
    throw http.ClientException('Invalid Request: $statusCode');
  } else if (statusCode >= 500 && statusCode < 600) {
    throw Exception('Server error occurred: $statusCode');
  } else {
    throw Exception('Failed to fetch poetry details: $statusCode');
  }
}
