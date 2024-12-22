import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.100.157:3000/api/v1';

  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateUserProfile({
    required int userId,
    required Map<String, dynamic> updatedData,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );
    return jsonDecode(response.body);
  }
}
