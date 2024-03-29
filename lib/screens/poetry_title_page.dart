import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poetry/model/poetry_title.dart';
import 'package:poetry/netowrks/fetch_poetry_title.dart';
import 'package:http/http.dart' as http;

class PoetryTitlePage extends StatelessWidget {
  const PoetryTitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peotry Title'),
      ),
      body: FutureBuilder<List<String>>(
        future: getPoetryTitleFromApiAlternate(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitWaveSpinner(
                color: Colors.blueAccent.shade200,
                waveColor: Colors.blueAccent.shade100,
                trackColor: Colors.white12,
                size: 100,
              ),
            );
          } else if (snapshot.hasError) {
            if (snapshot.error is TimeoutException) {
              return const Center(
                child: Text(
                    'Connection timeout. Please check your internet connection.'),
              );
            } else {
              return  Center(
                child: Text('An Error has occurred${snapshot.error.toString()}'),
              );
            }
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No poetry available.'),
            );
          } else {
            return ListView.separated(
              itemCount:  snapshot.data?.length ?? List.empty().length,
              itemBuilder: (context, index) {
                final poetry = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(poetry),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey.shade100,
                );
              },
            );
          }
        },
      ),
    );
  }
}
