import 'package:flutter/material.dart';

import 'Router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialApp(
        title: 'Project',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Router.onGenerateRoute,
        navigatorKey: Router.navigatorKey,
        initialRoute: Router.mainView,
        theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF000000),
          scaffoldBackgroundColor: Color(0xFF000000),
        ),
      ),
    );
  }
}

