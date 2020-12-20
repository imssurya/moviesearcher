import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moviesearcher/database/database.dart';
import 'package:moviesearcher/main.dart';
import 'package:moviesearcher/model/model.dart';
import 'package:moviesearcher/screens/movieview.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = List();
  bool hasLoaded = true;
  MovieDatabase db;
  final PublishSubject subject = PublishSubject<String>();
  @override
  void initState() {
    super.initState();
    db = MovieDatabase();
    db.initDb();
    subject.stream
        //.debounceTime(Duration(milliseconds: 400))
        .listen(searchMovies);
  }

  void searchMovies(query) {
    resetMovies();
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
      return;
    }
    setState(() {
      hasLoaded = false;
      http
          .get(
              'https://api.themoviedb.org/3/search/movie?api_key=$key&query=$query')
          .then((result) => result.body)
          .then(json.decode)
          .then((map) => map['results'])
          .then((movies) => movies.forEach(addMovie))
          .catchError(onError)
          .then((e) {
        setState(() {
          hasLoaded = true;
        });
      });
    });
  }

  void onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void addMovie(item) {
    setState(() {
      movies.add(Movie.fromJson(item));
    });
    print('${movies.map((e) => e.title)}');
  }

  void resetMovies() {
    setState(() {
      movies.clear();
    });
  }

  @override
  void dispose() {
    subject.close();
    db.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Searcher'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              // autocorrect: false,
              // keyboardType: TextInputType.text,
              onChanged: (String string) => (subject.add(string)),
            ),
            hasLoaded ? Container() : CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
                //itemExtent: 50,
                padding: EdgeInsets.all(10.0),
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  return MovieView(movies[index], db);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
