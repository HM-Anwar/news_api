import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/api_response.dart';

class ApiInt extends StatefulWidget {
  const ApiInt({Key? key}) : super(key: key);

  @override
  _ApiIntState createState() => _ApiIntState();
}

class _ApiIntState extends State<ApiInt> {
  Future<Welcome> getData() async {
    var response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=keyword&apiKey=51865635411d4f628534208f84a94e19'));
    var jsonData = jsonDecode(response.body);
    Welcome resData = Welcome.fromJson(jsonData);
    return resData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Welcome>(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            Welcome response = snapshot.data!;
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: response.articles.length,
                  itemBuilder: (context, index) {
                    Article art = snapshot.data!.articles[index];
                    return Card(
                      child: ListTile(
                        leading: Image.asset(art.urlToImage),
                        title: Text(art.author),
                        subtitle: Text(art.title),
                      ),
                    );
                  });
            }

            return Container();
          }),
    );
  }
}
