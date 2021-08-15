import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/components/content_cell.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/state/contents_state.dart';

class Contents extends StatelessWidget {
  final ContentType contentType;
  final GlobalKey<AnimatedListState> listKey;

  Contents({
    Key? key,
    required this.contentType,
    required this.listKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ContentsState>(
        builder: (context, state, child) {
          final contentsModel = contentType == ContentType.movie
              ? state.moviesModel
              : state.showsModel;

          return AnimatedList(
            padding: EdgeInsets.only(bottom: 24, top: 156),
            key: listKey,
            initialItemCount: contentsModel.length,
            itemBuilder: (context, index, animation) {
              final _animation = animation.drive(
                CurveTween(curve: Curves.easeOutCubic),
              );

              return SizeTransition(
                sizeFactor: _animation,
                child: FadeTransition(
                  opacity: _animation,
                  child: ContentCell(
                    content: contentsModel[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
