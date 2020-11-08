import 'package:googleapis/sheets/v4.dart';

import 'movie.dart';
import 'show.dart';

abstract class Content {
  final String title;
  final String year;
  final double rating;
  final DateTime addedOn;
  final DateTime watchedOn;

  Content({
    this.title,
    this.year,
    this.rating,
    this.addedOn,
    this.watchedOn,
  });

  static Content fromSheets(List<Object> properties) {
    if (properties[0] == "movie") {
      return Movie.fromSheets(properties);
    } else {
      return Show.fromSheets(properties);
    }
  }

  List<List<String>> toNewValues();
}

enum ContentType { movie, show }
