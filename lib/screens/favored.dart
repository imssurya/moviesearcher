import 'package:flutter/material.dart';
import 'package:moviesearcher/database/database.dart';
import 'package:moviesearcher/model/model.dart';
import 'package:rxdart/rxdart.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Movie> filterdMovies = List();
  List<Movie> movieCache = List();
  final PublishSubject subject = PublishSubject<String>();
  @override
  void initState() {
    filterdMovies = [];
    movieCache = [];
    subject.stream.listen(searchDataList);
    super.initState();
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void setUpList() async {
    MovieDatabase db = MovieDatabase();
    filterdMovies = await db.getMovies();
    setState(() {
      movieCache = filterdMovies;
    });
  }

  void searchDataList(query) {
    if (query.isEmpty) {
      setState(() {
        filterdMovies = movieCache;
      });
    }
    setState(() {
      filterdMovies = filterdMovies
          .where((m) => m.title
              .toLowerCase()
              .trim()
              .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
          .toList();
      setState(() {});
    });
  }

  void onPressed(int index) {
    setState(() {
      filterdMovies.remove(filterdMovies[index]);
    });
    MovieDatabase db = MovieDatabase();
    db.deleteMovies(filterdMovies[index].id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) => (subject.add(value)),
            keyboardType: TextInputType.url,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filterdMovies.length,
              itemBuilder: (BuildContext context, int index) {
                ExpansionTile(
                  initiallyExpanded: filterdMovies[index].isExpanded ?? false,
                  onExpansionChanged: (b) {
                    filterdMovies[index].isExpanded = b;
                  },
                  children: <Widget>[],
                  leading: IconButton(
                    icon: Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      onPressed(index);
                    },
                  ),
                  title: Container(
                    height: 200.0,
                    child: Row(
                      children: <Widget>[
                        filterdMovies[index].posterPath != null
                            ? Hero(
                                tag: filterdMovies[index].id,
                                child: Image.network(
                                    "https://image.imdb.org/t/p/w92${filterdMovies[index].posterPath}"))
                            : Container(),
                        Expanded(
                            child: Text(
                          filterdMovies[index].title,
                          textAlign: TextAlign.center,
                          maxLines: 10,
                        ))
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
