import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Cambia la IP si usas un celular real
  static const String baseUrl = "http://localhost:3000";

  // ========== LOGIN ==========
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // ========== REGISTER ==========
  static Future<Map<String, dynamic>> register(
      String nombre,
      String apellidos,
      String email,
      String telefono,
      String password) async {

    final url = Uri.parse("$baseUrl/register");

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

    return jsonDecode(response.body);
  }
}
