import 'package:flutter/material.dart';
import 'package:watchlist/models/content.dart';

class ContentTypeState extends ChangeNotifier {
  ContentType _contentType = ContentType.movie;

  ContentType get contentType => _contentType;

  void update(ContentType contentType) {
    _contentType = contentType;
    notifyListeners();
  }
}
