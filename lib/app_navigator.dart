import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/components/search_header.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/pages/movies.dart';
import 'package:watchlist/pages/shows.dart';
import 'package:watchlist/state/content_type.dart';

class AppNavigator extends StatefulWidget {
  final bool loading;

  const AppNavigator({Key key, this.loading}) : super(key: key);
  @override
  _AppNavigatorState createState() => new _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      Provider.of<ContentTypeState>(context, listen: false).update(
          _tabController.index == 0 ? ContentType.movie : ContentType.show);
    });

    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              Movies(),
              Shows(),
            ],
          ),
          SearchHeader(
            animation: _tabController.animation,
            loading: widget.loading,
          ),
        ],
      ),
    );
  }
}
