import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _offset = 0;
  String _search;

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null) {
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=4L4cuwGtONdZkyaebcerB322sNvwJKCO&limit=20&rating=g");
    } else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=4L4cuwGtONdZkyaebcerB322sNvwJKCO&q=${_search}&limit=20&offset=${_offset}&rating=g&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getGifs().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Image.network("https://luidimso.github.io/assets/img/logo.png"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Search here!",
                  border: OutlineInputBorder()
              ),
              style: TextStyle(
                  fontSize: 18
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
