import 'package:flutter/material.dart';
import 'package:massigym_flutter/models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailsScreen(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                movie.imageUrl,
                height: 500,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  movie.year.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  movie.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 22.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
