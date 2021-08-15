import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/app_navigator.dart';
import 'package:watchlist/state/content_type.dart';
import 'package:watchlist/state/contents_state.dart';

final moviesListKey = GlobalKey<AnimatedListState>();
final showsListKey = GlobalKey<AnimatedListState>();

main() async {
  await DotEnv().load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ContentsState(
                  showsListKey: showsListKey,
                  moviesListKey: moviesListKey,
                )),
        ChangeNotifierProvider(create: (context) => ContentTypeState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Scaffold(body: Text('error'));
          }

          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: MaterialApp(
              title: 'Watchlist',
              debugShowCheckedModeBanner: false,
              home: AppNavigator(
                moviesListKey: moviesListKey,
                showsListKey: showsListKey,
                loading: snapshot.connectionState != ConnectionState.done,
              ),
            ),
          );
        });
  }
}
