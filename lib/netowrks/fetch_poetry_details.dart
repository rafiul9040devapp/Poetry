import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poetry/utils/constants.dart';
import 'package:poetry/utils/helper.dart';

import '../model/poetry_details.dart';


Future<PoetryDetails> getPoetryDetailsFromApi2(http.Client client, String endPoint) async {

  print(endPoint);
  print(customEncode(endPoint));

  final Uri uri = Uri.parse('$baseUrl$title/${customEncode(endPoint)}');

  try {
    final http.Response response = await client.get(uri);
    final dynamic responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseBody is List && responseBody.isNotEmpty) {
        return PoetryDetails.fromJson(responseBody[0] as Map<String, dynamic>);
      } else {
        throw Exception('Invalid response format: Expected List<dynamic> with at least one item');
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw http.ClientException('Invalid Request: ${response.statusCode}');
    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      throw Exception('Server error occurred: ${response.statusCode}');
    } else {
      throw Exception('Failed to fetch poetry details: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch poetry details: $e');
  }
}





Future<PoetryDetails> getPoetryDetailsFromApi(
    http.Client client, String endPoint) async {

  print(endPoint);
  print(customEncode(endPoint));

  final Uri uri = Uri.parse('$baseUrl$title/${customEncode(endPoint)}');

  try {
    final http.Response response = await http.get(uri);
    final List<dynamic> responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return PoetryDetails.fromJson(responseBody[0] as Map<String,dynamic>);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw http.ClientException('Invalid Request: ${response.statusCode}');
      // throw http.ClientException(
      //     '${responseBody['reason']} : ${responseBody['status']}');
    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      throw Exception('Server error occurred: ${response.statusCode}');
    } else {
      throw Exception('Failed to fetch poetry details: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch poetry details: $e');
  }
}




Future<PoetryDetails> getPoetryDetailsFromApiAlternative(
    http.Client client, String endPoint) async {
  final Uri uri = Uri.parse('$baseUrl$title/${customEncode(endPoint)}');

  try {
    final http.Response response = await client.get(uri);
    return _handleResponse(response);
  } catch (e) {
    throw Exception('Failed to fetch poetry details: $e');
  }
}

PoetryDetails _handleResponse(http.Response response) {
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
}











