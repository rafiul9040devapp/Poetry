import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poetry/model/poetry_details.dart';
import 'package:poetry/netowrks/fetch_poetry_details.dart';
import 'package:http/http.dart' as http;
import 'package:poetry/utils/helper.dart';

class PoetryDetailsPage extends StatelessWidget {

  final String poetryTitle;

  const PoetryDetailsPage({super.key, required this.poetryTitle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PoetryDetails>(
      future: getPoetryDetailsFromApi(http.Client(), removeSpecialCharacters(poetryTitle)),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: SpinKitWaveSpinner(
              color: Colors.blueAccent.shade200,
              waveColor: Colors.blueAccent.shade100,
              trackColor: Colors.white12,
              size: 100,
            ),
          );
        }else if(snapshot.hasError){
          if(snapshot.error is TimeoutException){
            return const Center(
              child: Text(
                  'Connection timeout. Please check your internet connection.'),
            );
          }else{
            return  Center(
              child: Text('An Error has occurred${snapshot.error.toString()}'),
            );
          }
        }else if(snapshot.data ==null || snapshot.data!.lines!.isEmpty){
          return  Center(
            child: Text('No poetry details is available.${snapshot.error.toString()}'),
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data?.title ?? 'N/A'),
            ),
            body: Center(
              child: Text('Author: ${snapshot.data?.author ?? 'N/A'}'),
            ),
          );
        }
      },
    );
  }
}
