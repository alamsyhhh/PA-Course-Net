import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/product/create_product_controller.dart';

class CreateProductPage extends StatelessWidget {
  final int categoryId;

  CreateProductPage({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CreateProductForm(categoryId: categoryId),
      ),
    );
  }
}

class CreateProductForm extends StatefulWidget {
  final int categoryId;

  CreateProductForm({required this.categoryId});

  @override
  _CreateProductFormState createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final CreateProductController createProductController = Get.put(CreateProductController());
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      await createProductController.createProduct(
        name: _nameController.text,
        qty: int.parse(_qtyController.text),
        categoryId: widget.categoryId,
        image: _image,
      );

      setState(() {
        _isLoading = false;
      });

      Get.snackbar(
        'Success',
        'Product created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),
              _image == null
                  ? Text('No image selected.')
                  : SizedBox(
                width: 200,
                height: 300,
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitProduct,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.grey.withOpacity(0.1),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
