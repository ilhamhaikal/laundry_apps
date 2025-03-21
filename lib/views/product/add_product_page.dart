import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../data/services/product_service.dart';
import '../../data/services/uom_service.dart';
import '../../data/models/uom.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final ProductService _productService = ProductService();
  final UomService _uomService = UomService();

  String? _selectedUomId;
  List<Uom> _uoms = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUoms();
  }

  Future<void> _loadUoms() async {
    try {
      final uoms = await _uomService.getAllUoms();
      setState(() {
        _uoms = uoms;
        // Set default UOM if available
        if (_uoms.isNotEmpty && _selectedUomId == null) {
          _selectedUomId = _uoms.first.id;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load UOMs: $e')),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUomId == null || _selectedUomId!.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pilih UOM terlebih dahulu')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final selectedUom = _uoms.firstWhere(
          (uom) => uom.id == _selectedUomId,
          orElse: () => throw Exception('UOM tidak ditemukan'),
        );

        final newProduct = Product(
          id: '',
          name: _nameController.text.trim(),
          price: int.parse(_priceController.text),
          uomId: selectedUom.id.trim(),
          uomName: selectedUom.name,
        );

        print('Selected UOM ID: ${selectedUom.id}'); // Debug print
        print('Selected UOM Name: ${selectedUom.name}'); // Debug print

        await _productService.addProduct(newProduct);

        if (!mounted) return;

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text('Success'),
            content: Text('Product berhasil ditambahkan'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Gagal menambahkan product: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Product',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Harga tidak boleh kosong';
                  if (int.tryParse(value!) == null)
                    return 'Harga harus berupa angka';
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedUomId,
                decoration: InputDecoration(
                  labelText: 'Unit of Measurement',
                  border: OutlineInputBorder(),
                ),
                items: _uoms.map((uom) {
                  return DropdownMenuItem(
                    value: uom.id,
                    child: Text(uom.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUomId = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih unit of measurement' : null,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
