import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:poetry/model/poetry_of_authors.dart';
import 'package:poetry/model/poetry_title_alternative.dart';
import 'package:poetry/netowrks/best_practices/author_api.dart';
import 'package:poetry/netowrks/best_practices/poetry_api.dart';
import 'package:poetry/screens/poetry_details_page.dart';

class PoetryTitleAlternativePage extends StatelessWidget {
  final String? authorName;

  const PoetryTitleAlternativePage({Key? key, this.authorName});

  @override
  Widget build(BuildContext context) {
    final PoetryApi poetryApi = PoetryApi(http.Client());
    final AuthorApi authorApi = AuthorApi(http.Client());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Poetry Title'),
      ),
      body: authorName == null
          ? _buildFutureBuilder<PoetryTitleAlternative>(
              future: poetryApi.getPoetryTitle(),
              buildWidget: (snapshot) {
                if (snapshot.data == null || snapshot.data!.titles!.isEmpty) {
                  return _buildNoPoetryAvailableWidget();
                } else {
                  return _buildPoetryListWidget(snapshot.data!.titles ?? List.empty());
                }
              },
            )
          : _buildFutureBuilder<List<String>>(
              future: authorApi.getPoetryOfAuthorsAlternative(authorName!),
              buildWidget: (snapshot) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return _buildNoPoetryAvailableWidget();
                } else {
                  if (snapshot.data!.length == 1) {
                    Future.delayed(Duration.zero, () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PoetryDetailsPage(
                            poetryTitle: snapshot.data?[0] ?? '',
                          ),
                        ),
                      );
                    });
                    return SizedBox(); // Return an empty widget
                  }
                  return _buildPoetryListWidget(snapshot.data ?? []);
                }
              },
            ),

      // body: authorName == null
      //     ? FutureBuilder<PoetryTitleAlternative>(
      //         future: poetryApi.getPoetryTitle(),
      //         builder: (context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return _buildLoadingWidget();
      //           } else if (snapshot.hasError) {
      //             return _buildErrorWidget(snapshot);
      //           } else if (snapshot.data == null ||
      //               snapshot.data!.titles!.isEmpty) {
      //             return _buildNoPoetryAvailableWidget();
      //           } else {
      //             return _buildPoetryListWidget(snapshot.data?.titles ?? []);
      //           }
      //         },
      //       )
      //     : FutureBuilder<List<String>>(
      //         future: authorApi.getPoetryOfAuthorsAlternative(authorName!),
      //         builder: (context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return _buildLoadingWidget();
      //           } else if (snapshot.hasError) {
      //             return _buildErrorWidget(snapshot);
      //           } else if (snapshot.data == null ||
      //               snapshot.data!.isEmpty) {
      //             return _buildNoPoetryAvailableWidget();
      //           } else {
      //             return _buildPoetryListWidget(
      //                 snapshot.data ?? [] );
      //           }
      //         },
      //       ),
    );
  }

  Widget _buildFutureBuilder<T>({
    required Future<T> future,
    required Widget Function(AsyncSnapshot<T>) buildWidget,
  }) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot);
        } else {
          return buildWidget(snapshot);
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: SpinKitWaveSpinner(
        color: Colors.blueAccent.shade200,
        waveColor: Colors.blueAccent.shade100,
        trackColor: Colors.white12,
        size: 100,
      ),
    );
  }

  Widget _buildErrorWidget<T>(AsyncSnapshot<T> snapshot) {
    if (snapshot.error is TimeoutException) {
      return const Center(
        child: Text(
          'Connection timeout. Please check your internet connection.',
        ),
      );
    } else {
      return Center(
        child: Text('An Error has occurred: ${snapshot.error.toString()}'),
      );
    }
  }

  Widget _buildNoPoetryAvailableWidget() {
    return const Center(
      child: Text('No poetry available.'),
    );
  }

  Widget _buildPoetryListWidget(List<String> list) {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final poetry = list[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoetryDetailsPage(poetryTitle: poetry),
            ),
          ),
          child: Card(
            child: ListTile(
              title: Text(poetry),
            ),
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
}
