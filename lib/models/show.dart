import 'dart:math';

import 'package:to_watch/models/content.dart';

class Show implements Content {
  final String title;
  final int year;
  final double rating;
  final bool watched;

  Show(this.title, this.year, this.rating, this.watched);

  factory Show.fromTmdb(Map<String, dynamic> json) {
    final firstAirDate = json['first_air_date'].toString();
    final year = firstAirDate.substring(0, min(firstAirDate.length, 4));

    return Show(
      json['name'],
      year.isEmpty || year == "null" ? null : int.parse(year),
      json['vote_average'].toDouble() * 10,
      null,
    );
  }

  static List<Show> arrayFromTmdb(Map<String, dynamic> json) {
    List<Show> shows = List();
    final results = json['results'];
    final endRange = results.length < 3 ? results.length : 3;

    for (final result in results.getRange(0, endRange)) {
      shows.add(Show.fromTmdb(result));
    }

    return shows;
  }
}
