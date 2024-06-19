import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/product/products_detail_controller.dart';
import '../main_page.dart';

class UpdateProductPage extends StatefulWidget {
  final int productId;
  final ProductDetailController productDetailController =
  Get.put(ProductDetailController());

  UpdateProductPage({required this.productId});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();

  File? _image;

  final picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  fetchProductDetails() async {
    await widget.productDetailController.fetchProduct(widget.productId);
    final product = widget.productDetailController.product;
    if (product.isNotEmpty) {
      nameController.text = product['name'];
      qtyController.text = product['qty'].toString();
      categoryIdController.text = product['categoryId'].toString();
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void _submitProduct() async {
    if (!_isSubmitting) {
      setState(() {
        _isSubmitting = true;
      });

      final productDetailController = widget.productDetailController;
      await productDetailController.updateProduct(
        widget.productId,
        nameController.text,
        int.parse(qtyController.text),
        int.parse(categoryIdController.text),
        _image,
      );

      setState(() {
        _isSubmitting = false;
      });

      Get.offAll(MainScreen());

      Get.snackbar(
        'Success',
        'Product updated successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Obx(
                    () {
                  final product = widget.productDetailController.product;
                  if (product.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Product Name'),
                        ),
                        TextField(
                          controller: qtyController,
                          decoration: InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: categoryIdController,
                          decoration: InputDecoration(labelText: 'Category ID'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        _image == null
                            ? product['imageUrl'] != null
                            ? Image.network(
                          product['imageUrl'],
                          width: 200,
                          height: 200,
                        )
                            : Text('No image selected.')
                            : Image.file(_image!),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : getImage,
                          child: Text('Select Image'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitProduct,
                          child: Text('Update Product'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          if (_isSubmitting)
            Positioned.fill(
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}