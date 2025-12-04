import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Cambia la IP si usas un celular real
  static const String baseUrl = "http://localhost:3000";

  // ========== LOGIN ==========
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Error del servidor: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // ========== REGISTER ==========
  static Future<Map<String, dynamic>> register(
      String nombre,
      String apellidos,
      String email,
      String telefono,
      String password) async {

    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "apellidos": apellidos,
          "email": email,
          "telefono": telefono,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Error del servidor: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // ========== GET PRODUCTS ==========
  static Future<List<dynamic>> getProducts() async {
    final url = Uri.parse('$baseUrl/products');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['products'];
        } else {
          throw Exception(data['error'] ?? 'Error al obtener productos');
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ========== ORDERS ==========
  static Future<Map<String, dynamic>> createOrder(
      int userId, double total, List<dynamic> items) async {
    final url = Uri.parse('$baseUrl/orders');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'total': total,
          'items': items,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  static Future<List<dynamic>> getUserOrders(int userId) async {
    final url = Uri.parse('$baseUrl/orders/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['orders'];
        } else {
          throw Exception(data['error'] ?? 'Error al obtener ordenes');
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
