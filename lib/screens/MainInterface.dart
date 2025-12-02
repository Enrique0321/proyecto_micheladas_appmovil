import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_micheladas_appmovil/tab/home.dart';
import 'package:proyecto_micheladas_appmovil/tab/menu.dart';
import 'package:proyecto_micheladas_appmovil/tab/products.dart';
import 'package:proyecto_micheladas_appmovil/tab/perfil.dart';
import 'package:proyecto_micheladas_appmovil/tab/cart.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MainInterface extends StatefulWidget {
  final int initialPage;
  const MainInterface({super.key, this.initialPage = 0});

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  late int _page;
  String? userName;

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
  }

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    const HomeTab(),
    const MenuTab(),
    const CartTab(),
    const ProductsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9E2A1C), // Deep red/brown from image
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('asset/unnamed.png', fit: BoxFit.contain),
        ),
        actions: [
          if (userName != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  "Hola, $userName",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/LoginPage');
              },
              child: const Text(
                "Iniciar Sesión",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page, // Use _page instead of 0
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.menu, size: 30, color: Colors.white),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
          Icon(Icons.list_alt, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        backgroundColor: const Color(
          0xFF9E2A1C,
        ).withOpacity(0.5), // Changed to white to hide red background
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
