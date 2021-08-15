import 'dart:math';

import 'package:watchlist/models/content.dart';
import 'package:watchlist/extensions/string.dart';
import 'package:watchlist/extensions/object.dart';

class Movie implements Content {
  int? index;
  final String title;
  final String year;
  final double rating;
  final DateTime? addedOn;
  DateTime? watchedOn;

  @override
  ContentType get contentType => ContentType.movie;

  @override
  bool get isMovie => true;

  Movie({
    this.index,
    required this.title,
    required this.year,
    required this.rating,
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
    List<Movie> movies = [];
    final results = json['results'];
    final endRange = results.length < 3 ? results.length : 3;

    for (final result in results.getRange(0, endRange)) {
      movies.add(Movie.fromTmdb(result));
    }

    return movies;
  }

  static Movie fromSheets(List<Object> properties, int index) {
    String? indexString = properties[0].cast<String>()?.asNotEmpty();
    String? ratingString = properties[4].cast<String>()?.asNotEmpty();

    return Movie(
      index: indexString == null ? null : int.tryParse(indexString),
      title: properties[2].cast<String>() ?? "",
      year: properties[3].cast<String>() ?? "",
      rating: ratingString == null ? 0 : double.tryParse(ratingString) ?? 0,
      addedOn: DateTime.tryParse(properties[5].cast<String>() ?? ""),
      watchedOn: properties.length < 7
          ? null
          : DateTime.tryParse(properties[6].cast<String>() ?? ""),
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
