import 'package:flutter/material.dart';
import 'package:proyecto_micheladas_appmovil/screens/ForgotPasswordPage.dart';
import 'package:proyecto_micheladas_appmovil/screens/RegisterPage.dart';

import 'screens/LoginPage.dart';
import 'screens/MainInterface.dart';
import 'tab/menu.dart';

import 'package:provider/provider.dart';
import 'package:proyecto_micheladas_appmovil/services/cart_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: ComidaApp(),
    ),
  );
}

class ComidaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/MainInterface': (context) => const MainInterface(),
        '/register': (context) => const RegisterPage(),
        '/bruto': (context) => const ForgotPasswordPage(),
        '/menu': (context) => const MenuTab(), 
      },
    );
  }
}
