import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poetry/utils/constants.dart';

import '../../model/poetry_title_alternative.dart';

class PoetryApi {
  final http.Client _client;
  PoetryApi(this._client);

  Future<PoetryTitleAlternative> getPoetryTitle() async {
    final url = Uri.parse('$baseUrl$title');
    try {
      final http.Response response = await _client.get(url);
      final String utfResponseBody = utf8.decode(response.bodyBytes);
      final dynamic responseBody = jsonDecode(utfResponseBody);
      if (response.statusCode == 200) {
        return _parseResponseForTitle(responseBody);
      } else {
        _handleError(responseBody, response.statusCode);
      }
    } catch (e) {
      throw Exception('Failed to fetch poetry titles: $e');
    }

    // Should never reach here due to earlier error handling, but if it does, throw an exception
    throw Exception('Failed to fetch poetry titles');

  }

  PoetryTitleAlternative _parseResponseForTitle(dynamic responseBody) {
    return PoetryTitleAlternative.fromJson(responseBody);
  }




  void _handleError(dynamic responseBody, int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      throw http.ClientException(
          '${responseBody['reason']} : ${responseBody['status']}');
    } else if (statusCode >= 500 && statusCode < 600) {
      throw Exception('Server error occurred: $statusCode');
    } else {
      throw Exception('Failed to fetch poetry titles: $statusCode');
    }
  }
}
