import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/api/google_api.dart';
import 'package:watchlist/api/tmdb_api.dart';
import 'package:watchlist/components/search_bar_item.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/state/content_type.dart';
import 'package:watchlist/state/contents_state.dart';

class SearchBar extends StatefulWidget {
  final ContentTypeState contentTypeState;
  final bool isSignIn;
  final bool loading;

  const SearchBar({
    Key? key,
    required this.contentTypeState,
    required this.isSignIn,
    required this.loading,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  final _searchQuery = TextEditingController();
  final _focusNode = FocusNode();
  List<Content> _contents = [];
  bool _isLoading = false;
  Timer? _debounce;

  _setIsLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _reset() {
    setState(() {
      _contents = [];
      _isLoading = false;
    });
  }

  _onSearchChanged() {
    if (_searchQuery.text.isEmpty) {
      _reset();
      return;
    }

    if (_focusNode.hasFocus) {
      _setIsLoading();

      if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    }
  }

  _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _reset();
    } else {
      _onSearchChanged();
    }
  }

  _getData() async {
    if (_searchQuery.text.isEmpty) {
      return;
    }

    final function = widget.contentTypeState.contentType == ContentType.movie
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
    widget.contentTypeState.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChange);
    widget.contentTypeState.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    _debounce?.cancel();
    _contents = [];
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.isSignIn ? 0 : 32,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: widget.isSignIn ? 8 : 16,
        vertical: widget.isSignIn ? 8 : 0,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.isSignIn ? 32 : 24),
        ),
        border: Border.all(
          width: 1,
          color: Colors.black,
          style: BorderStyle.solid,
        ),
      ),
      child: Stack(
        children: widget.isSignIn
            ? [
                widget.loading
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: CupertinoActivityIndicator(),
                      )
                    : Image(
                        image: AssetImage("assets/icons/google.png"),
                      )
              ]
            : [
                buildTextField(),
                buildAnimatedSize(),
              ],
      ),
    );
  }

  TextField buildTextField() {
    return TextField(
      style: TextStyle(fontSize: 20),
      focusNode: _focusNode,
      controller: _searchQuery,
      decoration: InputDecoration(
        hintText: "Add a ${widget.contentTypeState.contentType.singular}",
        hintStyle: TextStyle(
          color: Color(0x45000000),
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  AnimatedSize buildAnimatedSize() {
    _handleTap(Content content) => () async {
          _setIsLoading();
          final newContent = await GoogleApi.addContent(content);
          Provider.of<ContentsState>(context, listen: false).add(newContent);

          _reset();
          _searchQuery.text = "";
          _focusNode.unfocus();
        };

    return AnimatedSize(
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
                      totalLength: _contents.length,
                      didTap: _handleTap(e.value),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
