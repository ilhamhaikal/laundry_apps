import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/uom.dart';
import '../../config/api.dart';

class UomService {
  Future<List<Uom>> getAllUoms() async {
    try {
      final response = await http.get(Uri.parse(API.uoms));
      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Periksa apakah ada data di response
        if (jsonResponse['data'] == null) {
          return []; // Kembalikan list kosong jika tidak ada data
        }

        // Konversi data ke List<Uom>
        return (jsonResponse['data'] as List)
            .map((item) => Uom.fromJson(item))
            .toList();
      } else {
        throw Exception('Gagal memuat data UOM: ${response.body}');
      }
    } catch (e) {
      print('Error dalam getAllUoms: $e'); // Debug print
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Uom> getUomById(String id) async {
    final response = await http.get(Uri.parse('${API.uoms}/$id'));
    if (response.statusCode == 200) {
      return Uom.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('UOM not found');
    }
  }

  Future<void> createUom(Uom uom) async {
    final response = await http.post(
      Uri.parse(API.uoms),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(uom.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create UOM');
    }
  }

  Future<void> updateUom(Uom uom) async {
    final response = await http.put(
      Uri.parse(API.uoms),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(uom.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update UOM');
    }
  }

  Future<void> deleteUom(String id) async {
    final response = await http.delete(Uri.parse('${API.uoms}/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete UOM');
    }
  }
}
