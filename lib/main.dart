import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesearcher/screens/homepage.dart';

void main() {
  runApp(MyApp());
}

const key = 'cd336fc35fe51a5ef4fac1cd2100f463';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie searcher",
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
