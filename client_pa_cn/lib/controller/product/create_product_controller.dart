import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/config.dart';

class CreateProductController extends GetxController {
  Future<void> createProduct({
    required String name,
    required int qty,
    required int categoryId,
    File? image,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final uri = Uri.parse('$apiUrl/products/');
      final request = http.MultipartRequest('POST', uri)
        ..fields['name'] = name
        ..fields['qty'] = qty.toString()
        ..fields['categoryId'] = categoryId.toString()
        ..headers['Authorization'] = 'Bearer $token';

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        Get.back();
      } else {
        print('Error: ${response.statusCode}');
        // Tambahkan penanganan kesalahan sesuai kebutuhan
      }
    } catch (e) {
      Get.offAllNamed('/login');
      print('Error during creating product: $e');
    }
  }
}
