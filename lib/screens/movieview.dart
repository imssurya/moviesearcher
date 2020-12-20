import 'package:flutter/material.dart';
import 'package:moviesearcher/database/database.dart';
import 'package:moviesearcher/model/model.dart';

class MovieView extends StatefulWidget {
  final Movie movie;
  MovieView(
    this.movie,
  );
  @override
  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  Movie movieState;
  @override
  void initState() {
    movieState = widget.movie;
    MovieDatabase db = MovieDatabase();
    db.getMovie(movieState.id).then((movie) {
      setState(() {
        movieState.favored = movie.favored;
      });
    });
    super.initState();
  }

  void onPressed() {
    MovieDatabase db = MovieDatabase();
    setState(() => movieState.favored = !movieState.favored);
    movieState.favored == true
        ? db.addMovie(movieState)
        : db.deleteMovies(movieState.id);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: movieState.isExpanded ?? false,
      onExpansionChanged: (value) => movieState.isExpanded = value,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: RichText(
            text: TextSpan(
                text: movieState.overview,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                )),
          ),
        )
      ],
      leading: IconButton(
        icon: movieState.favored ? Icon(Icons.star) : Icon(Icons.star_border),
        color: Colors.white,
        onPressed: () {
          onPressed();
        },
      ),
      title: Container(
        height: 200.0,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            movieState.posterPath != null
                ? Hero(
                    tag: movieState.id,
                    child: Image.network(
                        "https://image.tmdb.org/t/p/w92${movieState.posterPath}"))
                : Container(),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        movieState.title,
                        maxLines: 10,
                      ),
                    ),
                  ),

                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.arrow_downward,
                  //     ),
                  //     onPressed: () {},
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
