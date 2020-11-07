import 'dart:math';

import 'package:to_watch/models/content.dart';

class Movie implements Content {
  final String title;
  final int year;
  final double rating;
  final bool watched;

  Movie(this.title, this.year, this.rating, this.watched);

  factory Movie.fromTmdb(Map<String, dynamic> json) {
    final releaseDate = json['release_date'].toString();
    final year = releaseDate.substring(0, min(releaseDate.length, 4));

    return Movie(
      json['title'],
      year.isEmpty || year == "null" ? null : int.parse(year),
      json['vote_average'].toDouble() * 10,
      null,
    );
  }

  static List<Movie> arrayFromTmdb(Map<String, dynamic> json) {
    List<Movie> movies = List();
    final results = json['results'];
    final endRange = results.length < 3 ? results.length : 3;

    for (final result in results.getRange(0, endRange)) {
      movies.add(Movie.fromTmdb(result));
    }

    return movies;
  }
}
