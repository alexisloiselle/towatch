import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/components/search_header.dart';
import 'package:watchlist/constants.dart';
import 'package:watchlist/pages/contents.dart';
import 'package:watchlist/state/content_type.dart';

import 'models/content.dart';

class AppNavigator extends StatefulWidget {
  final bool loading;
  final GlobalKey<AnimatedListState> moviesListKey;
  final GlobalKey<AnimatedListState> showsListKey;

  const AppNavigator({
    Key? key,
    required this.loading,
    required this.moviesListKey,
    required this.showsListKey,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color _color = moviesColor;

  _handleChangeTab() {
    final contentType =
        _tabController.index == 0 ? ContentType.movie : ContentType.show;

    setState(() {
      _color = contentType.color;
    });

    Provider.of<ContentTypeState>(context, listen: false).update(contentType);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleChangeTab);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleChangeTab);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                Contents(
                  listKey: widget.moviesListKey,
                  contentType: ContentType.movie,
                ),
                Contents(
                  listKey: widget.showsListKey,
                  contentType: ContentType.show,
                ),
              ],
            ),
            SearchHeader(
              color: _color,
              loading: widget.loading,
            ),
          ],
        ),
      ),
    );
  }
}
