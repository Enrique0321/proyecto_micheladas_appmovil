import 'package:flutter/material.dart';

import 'screens/LoginPage.dart';
import 'screens/MainInterface.dart';

void main() => runApp(ComidaApp());

class ComidaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/MainInterface': (context) => const MainInterface(),
      },
    );
  }
}
