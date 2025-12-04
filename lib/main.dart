import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:proyecto_micheladas_appmovil/screens/ForgotPasswordPage.dart';
import 'package:proyecto_micheladas_appmovil/screens/RegisterPage.dart';

import 'screens/LoginPage.dart';
import 'screens/MainInterface.dart';
import 'tab/menu.dart';

import 'package:provider/provider.dart';
import 'package:proyecto_micheladas_appmovil/services/cart_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Stripe.publishableKey = 'pk_test_51ROJOiRIALrMjp8dh4iSQATcQVDUbDm11oa9d0sgU1MwxoQ9c8ELDs4FUyLzNJDjqorp0eUxv2iFDDPcekCQ8F1V00H44NX4s6';
  } catch (e) {
    print("Error initializing Stripe: $e");
  }

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
