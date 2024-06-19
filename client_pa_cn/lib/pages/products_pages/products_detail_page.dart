import 'package:client_pa_cn/pages/products_pages/update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/product/products_detail_controller.dart';
import '../main_page.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  final ProductDetailController productDetailController = Get.put(ProductDetailController());

  ProductDetailPage({required this.productId});

  @override
  Widget build(BuildContext context) {
    productDetailController.fetchProduct(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(context, productId);
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => UpdateProductPage(productId: productId));
            },
            icon: Icon(Icons.edit, color: Colors.black),
          ),
        ],
      ),
      body: Obx(
            () => productDetailController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : productDetailController.product.isEmpty
            ? Center(child: Text('Product not found'))
            : SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    productDetailController.product['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                productDetailController.product['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Quantity: ${productDetailController.product['qty']}',
                style: TextStyle(fontSize: 18, color: Colors.indigoAccent),
              ),
              SizedBox(height: 8.0),
              Divider(color: Colors.grey),
              SizedBox(height: 8.0),
              Text(
                'Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.0),
              Text(
                'Category: ${productDetailController.product['category']['name']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Created At: ${_formatDate(productDetailController.product['createdAt'])}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Updated At: ${_formatDate(productDetailController.product['updatedAt'])}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Created By: ${productDetailController.product['createdBy']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Updated By: ${productDetailController.product['updatedBy']}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                bool success = await productDetailController.deleteProduct(productId);
                Navigator.of(context).pop();
                if (success) {
                  Get.offAll(() => MainScreen());
                  Get.snackbar(
                    'Success',
                    'Product successfully deleted',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Failed to delete product',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('HH:mm, dd MMMM yyyy', 'id_ID');
    return formatter.format(dateTime);
  }
}
