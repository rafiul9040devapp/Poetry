import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poetry/model/poetry_of_authors.dart';
import 'package:poetry/utils/constants.dart';
import 'package:poetry/utils/helper.dart';
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

  Future<PoetryOfAuthors> getPoetryOfAuthors(String authorName) async {
    final uri = Uri.parse('$baseUrl$author/${customEncode(authorName)}$title');

    try {
      final http.Response response = await http.get(uri);
      final String utfResponseBody = utf8.decode(response.bodyBytes);
      final dynamic responseBody = jsonDecode(utfResponseBody);

      if (response.statusCode == 200) {
        return _parseResponseForPoetryOfAuthor(responseBody);
      } else {
        _handleError(responseBody, response.statusCode);
      }
    } catch (e) {
      throw Exception('Unable to Fetch Poetry Of Author $e');
    }
    throw Exception('Unable to Fetch Poetry Of Author');
  }
}

Author _parseResponseForAuthor(dynamic responseBody) {
  return Author.fromJson(responseBody);
}

PoetryOfAuthors _parseResponseForPoetryOfAuthor(dynamic responseBody) {
  return PoetryOfAuthors.fromJson(responseBody);
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
