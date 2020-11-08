import 'dart:math';

import 'package:watchlist/models/content.dart';
import 'package:watchlist/extensions/string.dart';
import 'package:watchlist/extensions/object.dart';

class Movie implements Content {
  final String title;
  final String year;
  final double rating;
  final DateTime addedOn;
  final DateTime watchedOn;

  Movie({
    this.title,
    this.year,
    this.rating,
    this.addedOn,
    this.watchedOn,
  });

  factory Movie.fromTmdb(Map<String, dynamic> json) {
    final releaseDate = json['release_date'].toString();
    final year = releaseDate.substring(0, min(releaseDate.length, 4));

    return Movie(
      title: json['title'],
      year: year,
      rating: json['vote_average'].toDouble() * 10,
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

  static Movie fromSheets(List<Object> properties) {
    return Movie(
      title: properties[1].cast<String>(),
      year: properties[2].cast<String>(),
      rating: double.tryParse(properties[3].cast<String>().asNotEmpty()) ?? 0,
      addedOn: DateTime.tryParse(properties[4].cast<String>()),
      watchedOn: properties.length < 6
          ? null
          : DateTime.tryParse(properties[5].cast<String>()),
    );
  }

  @override
  List<List<String>> toNewValues() {
    return List.from([
      [
        "movie",
        this.title,
        this.year.toString(),
        this.rating.toString(),
        DateTime.now().toIso8601String(),
      ],
    ]);
  }
}
