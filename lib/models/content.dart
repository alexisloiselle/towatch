import 'dart:ui';

import 'package:watchlist/constants.dart';

import 'movie.dart';
import 'show.dart';

abstract class Content {
  int index;
  final String title;
  final String year;
  final double rating;
  final DateTime addedOn;
  DateTime watchedOn;

  ContentType get contentType;

  Content({
    this.index,
    this.title,
    this.year,
    this.rating,
    this.addedOn,
    this.watchedOn,
  });

  static Content fromSheets(List<Object> properties, int index) {
    if (properties[0] == "movie") {
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
}
