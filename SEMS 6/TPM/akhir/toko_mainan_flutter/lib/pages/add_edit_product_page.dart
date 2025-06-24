import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_mainan_flutter/models/product.dart';
import 'package:toko_mainan_flutter/services/product_service.dart';
import 'package:toko_mainan_flutter/services/auth_service.dart'; // Required for auth headers

class AddEditProductPage extends StatefulWidget {
  final Product? product;

  const AddEditProductPage({super.key, this.product});

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService(); // Instantiate AuthService

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String name = _nameController.text;
        final String description = _descriptionController.text;
        final double price = double.parse(_priceController.text);
        final int stock = int.parse(_stockController.text);
        final String? token = await _authService.getToken();

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication token not found. Please login again.')),
          );
          setState(() { _isLoading = false; });
          Navigator.of(context).popUntil((route) => route.isFirst); // Go to login or splash
          return;
        }
        
        final Map<String, String> headers = {'Authorization': 'Bearer $token'};


        if (widget.product == null) {
          // Create product
          if (_imageFile == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select an image.')),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
          await _productService.createProduct(
            name: name,
            description: description,
            price: price,
            stock: stock,
            imageFile: _imageFile!,
            headers: headers,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product created successfully!')),
          );
        } else {
          // Update product
          await _productService.updateProduct(
            id: widget.product!.id,
            name: name,
            description: description,
            price: price,
            stock: stock,
            imageFile: _imageFile, // Image is optional for update
            headers: headers,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully!')),
          );
        }
        Navigator.of(context).pop(true); // Pop with a result to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save product: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product stock';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid stock quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _imageFile == null
                        ? (widget.product?.imageUrl != null && widget.product!.imageUrl.isNotEmpty
                            ? Image.network(widget.product!.imageUrl, height: 150, fit: BoxFit.cover)
                            : const Text('No image selected.'))
                        : Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Pick Image'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.product == null ? 'Create Product' : 'Update Product'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
