import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import '../../config/api.dart';

class CustomerService {
  Future<List<Customer>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse(API.customers));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] == null) {
          return [];
        }
        return (jsonResponse['data'] as List)
            .map((json) => Customer.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load customers: ${response.body}');
      }
    } catch (e) {
      print('Error in getCustomers: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Customer> getCustomerById(String id) async {
    try {
      final response = await http.get(Uri.parse('${API.customers}/$id'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Customer.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> createCustomer(Customer customer) async {
    try {
      final response = await http.post(
        Uri.parse(API.customers),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      print('Updating customer: ${customer.id}'); // Debug print
      print('Update URL: ${API.customers}'); // Debug print

      final response = await http.put(
        Uri.parse(API.customers),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(customer.toJson()),
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode != 200) {
        throw Exception('Failed to update customer: ${response.body}');
      }
    } catch (e) {
      print('Error in updateCustomer: $e'); // Debug print
      throw Exception('Network error: $e');
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      final response = await http.delete(Uri.parse('${API.customers}/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
