import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static const String _ordersKey = 'user_orders';

  // Save a new order
  static Future<void> saveOrder(Map<String, dynamic> order) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList(_ordersKey) ?? [];
    
    // Add new order to the beginning of the list
    orders.insert(0, jsonEncode(order));
    
    await prefs.setStringList(_ordersKey, orders);
  }

  // Get all orders
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList(_ordersKey) ?? [];
    
    return orders.map((order) => jsonDecode(order) as Map<String, dynamic>).toList();
  }
}
