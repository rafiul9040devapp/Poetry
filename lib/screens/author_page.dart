import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poetry/model/author.dart';
import 'package:poetry/netowrks/best_practices/author_api.dart';
import 'package:http/http.dart' as http;


class AuthorPage extends StatefulWidget {
  const AuthorPage({Key? key});

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  final AuthorApi authorApi = AuthorApi(http.Client());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: authorApi.getAuthor(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return _loadingWidget();
          } else if (snapshot.connectionState == ConnectionState.none) {
            return _noInternetWidget(context);
          } else if (snapshot.hasData) {
            return _checkTheData(snapshot);
          } else {
            return _unknownProblemWidget();
          }
        },
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: CupertinoColors.white,
      child: SpinKitChasingDots(
        color: Colors.blueAccent.shade100,
      ),
    );
  }

  Widget _noInternetWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: CupertinoColors.white,
      child: Center(
        child: ElevatedButton(
          onPressed: () => _showAlertDialog(context),
          child: const Text('No Internet Connection'),
        ),
      ),
    );
  }

  Widget _unknownProblemWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: CupertinoColors.white,
      child: const Center(
        child: Text(
          'Unknown Problem\nConnected to a terminated asynchronous computation.',
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _checkTheData(AsyncSnapshot<Author> snapshot) {
    if (snapshot.hasError) {
      if (snapshot.error is TimeoutException) {
        return const Center(
          child: Text('Connection timeout. Please check your internet connection.'),
        );
      } else {
        return Center(
          child: Text('An Error has occurred${snapshot.error.toString()}'),
        );
      }
    } else if (snapshot.data == null || snapshot.data!.authors!.isEmpty) {
      return const Center(
        child: Text('No Author is available.'),
      );
    } else {
      return _authorList(snapshot.data?.authors ?? List.empty());
    }
  }

  Widget _authorList(List<String> list) {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final author = list[index];
        return ListTile(
          title: Text(author),
        );
      },
      separatorBuilder: (context, index) {
        return  Divider(
          color: Colors.grey.shade100,
        );
      },
    );
  }
}
