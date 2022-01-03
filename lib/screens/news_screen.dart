import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/model/api_response_model.dart';

class ApiInt extends StatefulWidget {
  const ApiInt({Key? key}) : super(key: key);

  @override
  _ApiIntState createState() => _ApiIntState();
}

class _ApiIntState extends State<ApiInt> {
  Future<ApiResponse> getData() async {
    var response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=keyword&apiKey=51865635411d4f628534208f84a94e19'));
    var jsonData = jsonDecode(response.body);
    ApiResponse resData = ApiResponse.fromJson(jsonData);
    return resData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiResponse>(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            ApiResponse response = snapshot.data!;
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: response.articles.length,
                  itemBuilder: (context, index) {
                    Article article = snapshot.data!.articles[index];
                    return Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        title: Column(
                          children: [
                            article.urlToImage != 'null'
                                ? Container(
                                    width: double.infinity,
                                    height: 240,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(article.urlToImage),
                                          fit: BoxFit.fill),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(20),
                                    color: Colors.red,
                                    child: Text(
                                      "Image not available",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      article.source.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text(article.title),
                      ),
                    );
                  });
            }

            return Container();
          }),
    );
  }
}
