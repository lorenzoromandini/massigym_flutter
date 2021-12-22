import 'package:flutter/material.dart';

class Movie {
  String title;
  String description;
  String imageUrl;
  int year;

  Movie(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.year});
}

List<Movie> movieList = [
  Movie(title: "Porcoddio", description: "Diobestia", imageUrl: "assets/logo.png", year: 2021),
  Movie(title: "Bestiaaaa", description: "Pacca va in galera", imageUrl: "assets/cat_cardio.png", year: 2021),
  Movie(title: "Maonna", description: "Zeb torna a Bibbiena", imageUrl: "assets/logo.png", year: 2021),
  Movie(title: "Uzzio", description: "Pacca muore (good ending)", imageUrl: "assets/logo.png", year: 2021),
  Movie(title: "Pacca vive", description: "Pacca muore (bad ending)", imageUrl: "assets/logo.png", year: 2021),
  Movie(title: "Massi", description: "Massi e Mario fondano la Pacca SpA", imageUrl: "assets/logo.png", year: 2021),
];