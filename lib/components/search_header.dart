import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/api/auth.dart';
import 'package:watchlist/api/google_api.dart';
import 'package:watchlist/components/search_bar.dart';
import 'package:watchlist/constants.dart';
import 'package:watchlist/models/content.dart';
import 'package:watchlist/state/content_type.dart';
import 'package:watchlist/state/contents_state.dart';

class SearchHeader extends StatefulWidget {
  final AnimationController animation;
  final bool loading;

  const SearchHeader({Key key, this.animation, this.loading}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchHeaderState(animation, true);
}

class _SearchHeaderState extends State<SearchHeader> {
  final AnimationController animation;
  final bool isSignIn;
  Color _color = moviesColor;
  bool _isSignIn;

  _SearchHeaderState(this.animation, this.isSignIn);

  _changeColor() {
    setState(() {
      _color = Color.lerp(moviesColor, showsColor, animation.value);
    });
  }

  _handleSignIn() async {
    await Auth.signInWithGoogle();
    final contents = await GoogleApi.fetchWatchlist();
    Provider.of<ContentsState>(context, listen: false).addAll(contents);

    setState(() {
      _isSignIn = false;
    });
  }

  @override
  void initState() {
    super.initState();
    animation.addListener(_changeColor);
    _isSignIn = isSignIn;
  }

  @override
  void dispose() {
    animation.removeListener(_changeColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    double _y = _isSignIn ? 0.5 * height : 152;

    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      color: Colors.transparent,
      child: AnimatedContainer(
        width: width,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            buildBackdrop(width, _y),
            buildSearchBarWrapper(width),
          ],
        ),
      ),
    );
  }

  Transform buildSearchBarWrapper(double width) {
    return Transform.translate(
      offset: Offset(0, _isSignIn ? -32 : -24),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        width: _isSignIn ? 64 : width,
        child: GestureDetector(
          onTap: _isSignIn ? _handleSignIn : () {},
          child: Consumer<ContentTypeState>(
            builder: (context, state, child) => SearchBar(
              isSignIn: _isSignIn,
              loading: widget.loading,
              contentTypeState: state,
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildBackdrop(double width, double _y) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      width: width,
      height: _y - 24,
      decoration: BoxDecoration(
        color: _color,
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
    );
  }
}
