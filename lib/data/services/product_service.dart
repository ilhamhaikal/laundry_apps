import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../../config/api.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    try {
      print('Fetching products from: ${API.products}'); // Debug print

      final response = await http.get(
        Uri.parse(API.products),
        headers: {
          "Accept": "application/json",
        },
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if data exists
        if (jsonResponse['data'] == null) {
          return []; // Return empty list if no data
        }

        // Convert the data to List<Product>
        return (jsonResponse['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchProducts: $e'); // Debug print
      throw Exception('Network error: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      // Validate UOM ID
      if (product.uomId.isEmpty) {
        throw Exception('UOM ID cannot be empty');
      }

      final Map<String, dynamic> requestBody = {
        'name': product.name.trim(),
        'price': product.price,
        'uom_id': product.uomId.trim(), // Ensure no whitespace
      };

      print('Request body: ${jsonEncode(requestBody)}'); // Debug print

      final response = await http.post(
        Uri.parse(API.products),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print('Add product response: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode != 201) {
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      print('Error in addProduct: $e'); // Debug print
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse(API.products),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${API.products}/$id'),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
