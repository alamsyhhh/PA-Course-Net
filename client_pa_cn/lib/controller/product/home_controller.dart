import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/config.dart';
import '../../pages/auth_pages/login_page.dart';

class HomeController extends GetxController {
  var categories = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print('Fetched token: $token');

      if (token == null) {
        navigateToLogin();
        return;
      }

      final url = Uri.parse('$apiUrl/categories');

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        categories.value = decodedData['data'];
        isLoading.value = false;
      } else {
        navigateToLogin();
      }
    } catch (e) {
      print('Error fetching categories: $e');
      navigateToLogin();
    }
  }

  void navigateToLogin() {
    Get.offAll(() => LoginScreen());
  }
}
