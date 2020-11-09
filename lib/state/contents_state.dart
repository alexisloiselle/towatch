import 'package:flutter/material.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/models/movie.dart';
import 'package:watchlist/models/show.dart';

import 'list_model.dart';

int _addedOnSorter(Content a, Content b) {
  return a.addedOn == null
      ? 1
      : b.addedOn == null
          ? -1
          : b.addedOn.compareTo(a.addedOn);
}

int _watchedOnSorter(Content a, Content b) {
  return a.watchedOn == null
      ? -1
      : b.watchedOn == null
          ? 1
          : 0;
}

class ContentsState extends ChangeNotifier {
  final GlobalKey<AnimatedListState> moviesListKey;
  final GlobalKey<AnimatedListState> showsListKey;

  ListModel<Movie> _movies;
  ListModel<Show> _shows;

  ContentsState({
    this.moviesListKey,
    this.showsListKey,
  }) {
    _movies = ListModel(
      listKey: moviesListKey,
      removedItemBuilder: (_, __, ___) {},
      initialItems: [],
    );
    _shows = ListModel(
      listKey: showsListKey,
      removedItemBuilder: (_, __, ___) {},
      initialItems: [],
    );
  }

  ListModel<Movie> get moviesModel => _movies;
  ListModel<Show> get showsModel => _shows;

  void add(Content content) {
    switch (content.contentType) {
      case ContentType.movie:
        _movies.insert(0, content);
        break;
      default:
        _shows.insert(0, content);
        break;
    }
    notifyListeners();
  }

  void addAll(List<Content> contents) {
    final movies = contents
        .where((c) => c is Movie)
        .map((e) => e as Movie)
        .toList()
          ..sort(_addedOnSorter)
          ..sort(_watchedOnSorter);

    final shows = contents
        .where((c) => c is Show)
        .map((e) => e as Show)
        .toList()
          ..sort(_addedOnSorter)
          ..sort(_watchedOnSorter);

    for (int i = 0; i < movies.length; i++) {
      _movies.insert(i, movies[i]);
    }

    for (int i = 0; i < shows.length; i++) {
      _shows.insert(i, shows[i]);
    }

    notifyListeners();
  }
}
