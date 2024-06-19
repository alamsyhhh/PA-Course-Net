import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/config.dart';
import '../../pages/auth_pages/login_page.dart';

class ProductDetailController extends GetxController {
  var product = {}.obs;
  var isLoading = true.obs;

  Future<void> fetchProduct(int productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        _navigateToLogin();
        return;
      }

      final url = Uri.parse('$apiUrl/products/$productId');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        product.value = decodedData['data'];
        isLoading.value = false;
        print(decodedData);
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      _navigateToLogin();
      print('Error during fetching product: $e');
    }
  }

  Future<bool> deleteProduct(int productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        _navigateToLogin();
        return false;
      }

      final url = Uri.parse('$apiUrl/products/$productId');

      final response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _navigateToLogin();
      print('Error during deleting product: $e');
      return false;
    }
  }

  Future<void> updateProduct(int productId, String name, int qty, int categoryId, File? image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        _navigateToLogin();
        return;
      }

      final uri = Uri.parse('$apiUrl/products/$productId');
      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['qty'] = qty.toString()
        ..fields['categoryId'] = categoryId.toString();

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.back();
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      _navigateToLogin();
      print('Error during updating product: $e');
    }
  }

  void _navigateToLogin() {
    Get.offAll(LoginScreen());
  }
}
