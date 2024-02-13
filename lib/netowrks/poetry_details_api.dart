import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/poetry_details.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';

class PoetryDetailsApi {
  final http.Client _client;

  PoetryDetailsApi(this._client);

  Future<PoetryDetails> getPoetryDetails(String endPoint) async {
    final Uri uri = Uri.parse('$BASE_URL$TITLE_END_POINT/${customEncode(endPoint)}');

    try {
      final http.Response response = await _client.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = _parseResponse(response);
        return PoetryDetails.fromJson(responseBody);
      } else {
        _handleError(response.statusCode);
      }
    } catch (e) {
      throw Exception('Failed to fetch poetry details: $e');
    }

    // Should never reach here due to earlier error handling, but if it does, throw an exception
    throw Exception('Failed to fetch poetry details');
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    final String utfResponseBody = utf8.decode(response.bodyBytes);
    final dynamic responseBody = jsonDecode(utfResponseBody);
    if (responseBody is! List || responseBody.isEmpty) {
      throw Exception('Invalid response format: Expected List<dynamic> with at least one item');
    }
    return responseBody[0] as Map<String, dynamic>;
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
}
