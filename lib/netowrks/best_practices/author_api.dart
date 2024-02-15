import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poetry/utils/constants.dart';
import '../../model/author.dart';

class AuthorApi {
  final http.Client _client;

  AuthorApi(this._client);

  Future<Author> getAuthor() async {
    final uri = Uri.parse('$baseUrl$author');

    try {
      final http.Response response = await _client.get(uri);
      final String utfResponseBody = utf8.decode(response.bodyBytes);
      final dynamic responseBody = jsonDecode(utfResponseBody);

      if (response.statusCode == 200) {
        return _parseResponseForAuthor(responseBody);
      } else {
        _handleError(responseBody, response.statusCode);
      }
    } catch (e) {
      throw Exception('Unable to Fetch Author $e');
    }
    throw Exception('Unable to Fetch Author');
  }
}

Author _parseResponseForAuthor(dynamic responseBody) {
  return Author.fromJson(responseBody);
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
