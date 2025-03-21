import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Attempting login to: ${API.users}'); // Debug print

      final response = await http.get(
        Uri.parse('${API.users}?username=$username&password=$password'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Login gagal: ${response.body}");
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception("Network error: $e");
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String username, String password) async {
    try {
      print('Attempting register to: ${API.users}'); // Debug print

      final response = await http.post(
        Uri.parse(API.users),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Registrasi gagal: ${response.body}");
      }
    } catch (e) {
      print('Error during register: $e');
      throw Exception("Network error: $e");
    }
  }
}
