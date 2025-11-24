import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/LoginPage.dart';
import 'screens/HomePage.dart';
import 'screens/MainInterface.dart';

void main() => runApp(ComidaApp());

class ComidaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 👇 Pantalla inicial
      initialRoute: '/login',

      // 👇 Rutas de la app
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/comida': (context) => ComidaScreen(),
        '/MainInterface': (context) => const MainInterface(),
      },
    );
  }
}

// --------------------------
//   Pantalla Comida (igual)
// --------------------------

class ComidaScreen extends StatefulWidget {
  @override
  _ComidaScreenState createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<ComidaScreen> {
  List<Comida> _comida = [];

  @override
  void initState() {
    super.initState();
    _fetchComida();
  }

  Future<void> _fetchComida() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:3000/api/comida'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        _comida = jsonData.map((item) => Comida.fromJson(item)).toList();
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comida List')),
      body: ListView.builder(
        itemCount: _comida.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_comida[index].titulo),
            subtitle: Text(_comida[index].author),
          );
        },
      ),
    );
  }
}

class Comida {
  final int id;
  final String titulo;
  final String author;

  Comida({required this.id, required this.titulo, required this.author});

  factory Comida.fromJson(Map<String, dynamic> json) {
    return Comida(
      id: json['id'],
      titulo: json['titulo'],
      author: json['cocine'],
    );
  }
}
