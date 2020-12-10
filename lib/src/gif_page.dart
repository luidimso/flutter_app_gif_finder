import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {

  final Map _gif;

  GifPage(this._gif);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gif["title"]),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Image.network(_gif["images"]["fixed_height"]["url"])
      ),
    );
  }
}
