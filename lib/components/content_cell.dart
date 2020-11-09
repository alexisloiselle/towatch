import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlist/api/google_api.dart';
import 'package:watchlist/models/content.dart';

class ContentCell extends StatefulWidget {
  final Content content;

  const ContentCell({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  _ContentCellState createState() => _ContentCellState();
}

class _ContentCellState extends State<ContentCell> {
  bool _checkmarkLoading = false;

  _onCheckmarkTap() async {
    setState(() {
      _checkmarkLoading = true;
    });
    await GoogleApi.toggleWatchedOn(widget.content);
    setState(() {
      _checkmarkLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: width - 64,
      height: 80,
      padding: EdgeInsets.only(left: 24, right: 8),
      margin: EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: 24,
      ),
      decoration: BoxDecoration(
          color: widget.content.contentType.color,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              offset: Offset(2, 2),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildInfo(),
          SizedBox(
            width: 8,
          ),
          buildCheckmarkSection()
        ],
      ),
    );
  }

  Expanded buildInfo() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.content.title.replaceAll("", "\u{200B}"),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                widget.content.year,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  "${widget.content.rating.round()}%",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  GestureDetector buildCheckmarkSection() {
    return GestureDetector(
      onTap: _onCheckmarkTap,
      child: Container(
        width: 64,
        height: 64,
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            style: BorderStyle.solid,
            color: Colors.black,
            width: 1,
          ),
        ),
        child: _checkmarkLoading
            ? CupertinoActivityIndicator()
            : widget.content.watchedOn == null
                ? null
                : Image.asset("assets/images/checkmark.png"),
      ),
    );
  }
}
