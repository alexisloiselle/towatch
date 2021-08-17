import 'package:flutter/material.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/extensions/string.dart';

typedef void VoidCallback();

class SearchBarItem extends StatelessWidget {
  final int index;
  final Content content;
  final int totalLength;
  final VoidCallback didTap;

  const SearchBarItem({
    Key? key,
    required this.index,
    required this.content,
    required this.totalLength,
    required this.didTap,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                content.year.asNotEmpty() != null
                    ? Row(
                        children: [
                          Text(
                            content.year.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color(0x99000000),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      )
                    : Container(),
                Text("${content.rating.round().toString()}%",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0x99000000),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
