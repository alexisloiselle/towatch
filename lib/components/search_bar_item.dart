import 'package:flutter/material.dart';
import 'package:to_watch/models/content.dart';

class SearchBarItem extends StatelessWidget {
  final int index;
  final Content content;
  final int totalLength;

  const SearchBarItem({Key key, this.index, this.content, this.totalLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: index == 0 ? 64 : 8, bottom: index == totalLength - 1 ? 16 : 0),
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
    );
  }
}
