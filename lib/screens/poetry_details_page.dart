import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poetry/model/poetry_details.dart';
import 'package:poetry/netowrks/best_practices/poetry_details_api.dart';
import 'package:http/http.dart' as http;


class PoetryDetailsPage extends StatelessWidget {

  final String poetryTitle;

  const PoetryDetailsPage({super.key, required this.poetryTitle});

  @override
  Widget build(BuildContext context) {

    final PoetryDetailsApi poetryDetailsApi = PoetryDetailsApi(http.Client());

    return FutureBuilder<PoetryDetails>(
      future: poetryDetailsApi.getPoetryDetails(poetryTitle),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            color: Colors.white,
            child: Center(
              child: SpinKitWaveSpinner(
                color: Colors.blueAccent.shade200,
                waveColor: Colors.blueAccent.shade100,
                trackColor: Colors.white12,
                size: 100,
              ),
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
        }else if(snapshot.data ==null || snapshot.data!.lines.isEmpty){
          return  Center(
            child: Text('No poetry details is available.${snapshot.error.toString()}'),
          );
        }else{
          return
            Scaffold(
              appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(snapshot.data?.title ?? 'N/A'),
                  Text('Author: ${snapshot.data?.author ?? 'N/A'}'),
                ],
              ),
            ),
                      );
        }
      },
    );
  }
}
