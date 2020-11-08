import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/api/google_api.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/state/contents_state.dart';

typedef void VoidCallback();

class SearchBarItem extends StatelessWidget {
  final int index;
  final Content content;
  final int totalLength;
  final VoidCallback didTap;

  const SearchBarItem({
    Key key,
    this.index,
    this.content,
    this.totalLength,
    this.didTap,
  }) : super(key: key);

  _handleTap() => didTap();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: index == 0 ? 64 : 8,
            bottom: index == totalLength - 1 ? 16 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.title,
              textAlign: TextAlign.start,
            ),
            Text(
              content.year.toString(),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
