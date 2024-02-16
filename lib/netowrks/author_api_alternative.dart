import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poetry/model/author.dart';
import 'package:poetry/model/poetry_of_authors.dart';
import 'package:poetry/utils/constants.dart';
import 'package:poetry/utils/helper.dart';

class AuthorApiAlternative {
  final http.Client _client;

  AuthorApiAlternative(this._client);

  Future<Author> getAuthor() async {
    try {
      final uri = Uri.parse('$baseUrl$author');
      final response = await _client.get(uri);
      return _handleResponse<Author>(response, _parseAuthor);
    } catch (e) {
      throw Exception('Failed to fetch author: $e');
    }
  }

  Future<PoetryOfAuthors> getPoetryOfAuthors(String authorName) async {
    try {
      final uri = Uri.parse('$baseUrl$author/${customEncode(authorName)}$title');
      final response = await _client.get(uri);
      return _handleResponse<PoetryOfAuthors>(response, _parsePoetryOfAuthors);
    } catch (e) {
      throw Exception('Failed to fetch poetry of author: $e');
    }
  }

  Future<List<String>> getPoetryOfAuthorsAlternative(String authorName) async {
    try {
      final uri = Uri.parse('$baseUrl$author/${customEncode(authorName)}$title');
      final response = await _client.get(uri);
      return _handleResponse<List<String>>(response, _parsePoetryTitles);
    } catch (e) {
      throw Exception('Failed to fetch poetry titles of author: $e');
    }
  }

  T _handleResponse<T>(http.Response response, Function(dynamic) parser) {
    final utfResponseBody = utf8.decode(response.bodyBytes);
    final dynamic responseBody = jsonDecode(utfResponseBody);
    if (response.statusCode == 200) {
      return parser(responseBody) as T;
    } else {
      throw _handleError(responseBody, response.statusCode);
    }
  }

  Author _parseAuthor(dynamic responseBody) {
    return Author.fromJson(responseBody);
  }

  PoetryOfAuthors _parsePoetryOfAuthors(dynamic responseBody) {
    return PoetryOfAuthors.fromJson(responseBody);
  }

  List<String> _parsePoetryTitles(dynamic responseBody) {
    return List<String>.from(responseBody.map((item) => item['title'] as String));
  }

  Exception _handleError(dynamic responseBody, int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      return http.ClientException('${responseBody['reason']} : ${responseBody['status']}');
    } else if (statusCode >= 500 && statusCode < 600) {
      return Exception('Server error occurred: $statusCode');
    } else {
      return Exception('Failed to fetch poetry titles: $statusCode');
    }
  }
}
