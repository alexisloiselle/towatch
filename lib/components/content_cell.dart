import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/api/google_api.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/state/contents_state.dart';

class ContentCell extends StatefulWidget {
  final Content content;

  const ContentCell({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  _ContentCellState createState() => _ContentCellState();
}

class _ContentCellState extends State<ContentCell>
    with SingleTickerProviderStateMixin {
  bool _checkmarkLoading = false;
  AnimationController _controller;

  _onCheckmarkTap() async {
    setState(() {
      _checkmarkLoading = true;
    });
    final content = await GoogleApi.toggleWatchedOn(widget.content);
    Provider.of<ContentsState>(context, listen: false).toggleWatchedOn(content);
    setState(() {
      _checkmarkLoading = false;
    });
  }

  _statusListener(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await GoogleApi.delete(widget.content);
      Provider.of<ContentsState>(context, listen: false).remove(widget.content);
      Timer(const Duration(milliseconds: 200), () {
        _controller.reset();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      reverseDuration: Duration(milliseconds: 300),
    );
    _controller.addStatusListener(_statusListener);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onLongPress: _controller.forward,
      onLongPressEnd: (details) {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _controller.drive(Tween<double>(begin: 1.0, end: 0.0)),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: width - 64,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(
            top: 22,
            left: 32,
            right: 32,
            bottom: 2,
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
        ),
      ),
    );
  }

  Expanded buildInfo() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 16),
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _checkmarkLoading ? 1 : 0,
                child: CupertinoActivityIndicator()),
            AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _checkmarkLoading ? 0 : 1,
                child: widget.content.watchedOn == null
                    ? null
                    : Image.asset("assets/images/checkmark.png"))
          ],
        ),
      ),
    );
  }
}
