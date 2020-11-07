import 'package:flutter/material.dart';
import 'package:to_watch/components/search_bar.dart';
import 'package:to_watch/constants.dart';
import 'package:to_watch/models/content.dart';

class SearchHeader extends StatelessWidget {
  final double animationValue;

  const SearchHeader({Key key, this.animationValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        height: 152,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            width: width,
            height: 128,
            decoration: BoxDecoration(
              color: Color.lerp(moviesColor, showsColor, animationValue),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
              border: Border.all(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
          Positioned(
            top: 96,
            right: 0,
            left: 0,
            child: SearchBar(
              type:
                  animationValue == 0.0 ? ContentType.movie : ContentType.show,
            ),
          )
        ]),
      ),
    );
  }
}
