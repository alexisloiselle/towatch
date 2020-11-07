import 'package:flutter/material.dart';
import 'package:to_watch/components/search_header.dart';
import 'package:to_watch/models/content.dart';
import 'package:to_watch/pages/movies.dart';
import 'package:to_watch/pages/shows.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key key}) : super(key: key);
  @override
  AppNavigatorState createState() => new AppNavigatorState();
}

class AppNavigatorState extends State<AppNavigator>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeIndex = 0;
  double _animationValue = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

    _tabController.animation.addListener(() {
      setState(() {
        _animationValue = _tabController.animation.value;
      });
    });

    _tabController.addListener(() {
      setState(() {
        _activeIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          SearchHeader(animationValue: _animationValue),
        ],
      ),
    );
  }
}
