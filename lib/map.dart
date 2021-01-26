import 'package:flutter/material.dart';

class FindPage extends StatefulWidget{
  FindPage({Key key}) : super(key: key);
  @override
  _FindPage createState() => _FindPage();
}

class _FindPage extends State<FindPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Find A Recycle Location"),
      ),
    );
  }
}
