import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/models/movie.dart';
import 'package:watchlist/models/show.dart';

class ContentsState extends ChangeNotifier {
  List<Content> _contents = [];

  UnmodifiableListView<Content> get shows => UnmodifiableListView(
        _contents.where((element) => element is Show),
      );

  UnmodifiableListView<Content> get movies => UnmodifiableListView(
        _contents.where((element) => element is Movie),
      );

  void add(Content content) {
    _contents.add(content);
    notifyListeners();
  }

  void addAll(List<Content> contents) {
    _contents.addAll(contents);
    notifyListeners();
  }

  void update(List<Content> contents) {
    _contents = contents;
    notifyListeners();
  }

  void removeAll() {
    _contents.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    removeAll();
    super.dispose();
  }
}
