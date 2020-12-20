import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesearcher/screens/favored.dart';
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
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Movie searcher App"),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.home),
                      text: 'Home page',
                    ),
                    Tab(
                      icon: Icon(Icons.favorite),
                      text: "Favorites",
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  HomePage(),
                  Favorites(),
                ],
              ),
            )));
  }
}
