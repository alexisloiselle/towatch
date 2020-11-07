import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_watch/api/tmdb_api.dart';
import 'package:to_watch/components/search_bar_item.dart';
import 'package:to_watch/models/content.dart';

class SearchBar extends StatefulWidget {
  final ContentType type;

  const SearchBar({Key key, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  final _searchQuery = TextEditingController();
  final _focusNode = FocusNode();
  List<Content> _contents = List();
  bool _isLoading = false;
  Timer _debounce;

  _onSearchChanged() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isLoading = true;
      });
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    }
  }

  _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isLoading = false;
        _contents = List();
      });
    } else {
      _onSearchChanged();
    }
  }

  _getData() async {
    if (_searchQuery.text.isEmpty) {
      setState(() {
        _contents = List();
        _isLoading = false;
      });
      return;
    }

    final function = widget.type == ContentType.movie
        ? TmdbApi.queryMovies
        : TmdbApi.queryShows;

    final data = await function(_searchQuery.text);
    setState(() {
      if (data is List<Content>) {
        _contents = data;
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    _debounce?.cancel();
    _contents = List();
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          border: Border.all(
              width: 1, color: Colors.black, style: BorderStyle.solid)),
      child: Stack(
        children: <Widget>[
          TextField(
            focusNode: _focusNode,
            controller: _searchQuery,
            decoration: InputDecoration(
              hintText: "Add",
              hintStyle: TextStyle(color: Color(0x45000000)),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            vsync: this,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _isLoading
                    ? [
                        Container(
                          margin: EdgeInsets.only(top: 64, bottom: 16),
                          width: double.infinity,
                          child: CupertinoActivityIndicator(),
                        )
                      ]
                    : _contents
                        .asMap()
                        .entries
                        .map(
                          (e) => SearchBarItem(
                              content: e.value,
                              index: e.key,
                              totalLength: _contents.length),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
