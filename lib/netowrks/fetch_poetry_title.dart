import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poetry/utils/constants.dart';

import '../model/poetry_title.dart';

Future<PoetryTitle> getPoetryTitleFromApi(http.Client client) async {
  final Uri url = Uri.parse(BASE_URL + TITLE_END_POINT);
  try {
    final http.Response response = await client.get(url);
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return PoetryTitle.fromJson(responseBody['titles']);
    } else if ((response.statusCode ~/ 100) == 4) {
      throw Exception('${responseBody['reason']} : ${responseBody['status']}');

    } else {
      throw Exception('Failed to fetch poetry titles: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch poetry titles: $e');
    print('${e}');
  }
}

Future<PoetryTitle> getPoetryTitleFromApiAlternate(http.Client client) async {
  final url = Uri.parse(BASE_URL + TITLE_END_POINT);

  try {
    final response = await client.get(url);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return PoetryTitle.fromJson(responseBody['titles']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw http.ClientException(
          '${responseBody['reason']} : ${responseBody['status']}');
    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      throw Exception('Server error occurred: ${response.statusCode}');
    } else {
      throw Exception('Failed to fetch poetry titles: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch poetry titles: $e');
  }
}
