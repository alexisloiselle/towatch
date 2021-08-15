import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/api/auth.dart';
import 'package:watchlist/api/google_api.dart';
import 'package:watchlist/components/search_bar.dart';
import 'package:watchlist/state/content_type.dart';
import 'package:watchlist/state/contents_state.dart';

class SearchHeader extends StatefulWidget {
  final Color color;
  final bool loading;

  const SearchHeader({
    Key? key,
    required this.color,
    required this.loading,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  bool _isSignIn = true;
  bool _loading = true;

  _SearchHeaderState();

  _trySignInSilently() async {
    final user = await Auth.signInSilently();
    if (user != null) {
      await _fetchList();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  _handleSignIn() async {
    setState(() {
      _loading = true;
    });

    final user = await Auth.signInWithGoogle();
    if (user != null) {
      await _fetchList();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  _fetchList() async {
    final contents = await GoogleApi.fetchWatchlist();
    Provider.of<ContentsState>(context, listen: false).addAll(contents);

    setState(() {
      _isSignIn = false;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _trySignInSilently();
  }

  @override
  void dispose() {
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
              loading: widget.loading || _loading,
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
        color: widget.color,
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
