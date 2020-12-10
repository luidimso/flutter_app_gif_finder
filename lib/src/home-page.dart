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
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=4L4cuwGtONdZkyaebcerB322sNvwJKCO&q=${_search}&limit=19&offset=${_offset}&rating=g&lang=en");
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
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          strokeWidth: 5,
                        )
                      );
                    default:
                      if(snapshot.hasError) return Container();
                      else return _createGifTable(context, snapshot);
                  }
                },
              )
          )
        ],
      ),
    );
  }

  int _getItemCount(List data) {
    if(_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      itemCount: _getItemCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if(_search == null || index < snapshot.data["data"].length)
          return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover
            ),
          );
        else
          return Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add,
                    color: Colors.green,
                    size: 70
                  ),
                  Text("Load more...",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 22
                    ),
                  )
                ],
              ),
            ),
          );
      }
    );
  }
}
