abstract class Content {
  final String title;
  final int year;
  final double rating;
  final bool watched;

  Content(this.title, this.year, this.rating, this.watched);
}

enum ContentType { movie, show }
