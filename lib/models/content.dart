import 'dart:ui';

import 'package:watchlist/constants.dart';

import 'movie.dart';
import 'show.dart';

abstract class Content {
  int? index;
  final String title;
  final String year;
  final double rating;
  final DateTime? addedOn;
  DateTime? watchedOn;

  ContentType get contentType;
  bool get isMovie;

  Content({
    this.index,
    required this.title,
    required this.year,
    required this.rating,
    this.addedOn,
    this.watchedOn,
  });

  static Content fromSheets(List<Object> properties, int index) {
    if (properties[1] == "movie") {
      return Movie.fromSheets(properties, index);
    } else {
      return Show.fromSheets(properties, index);
    }
  }

  List<List<String>> toNewValues();
}

enum ContentType { movie, show }

extension ContentTypeExtension on ContentType {
  Color get color => this == ContentType.movie ? moviesColor : showsColor;
  String get title => this == ContentType.movie ? "Movies" : "Shows";
  String get singular => this == ContentType.movie ? "movie" : "show";
}
