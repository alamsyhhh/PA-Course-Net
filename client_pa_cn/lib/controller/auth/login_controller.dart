import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/config.dart';
import '../../widgets/toast.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showAlertDialog('Error', 'Please fill in all fields.');
      return;
    }

    try {
      isLoading(true);
      final url = Uri.parse('$apiUrl/users/login');

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.post(
        url,
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print('Login successful, saving token...');

        final prefs = await SharedPreferences.getInstance();
        final token = decodedData['data']['token'];
        await prefs.setString('token', token);

        final storedToken = prefs.getString('token');
        print('Stored token: $storedToken');

        showToast(message: "User is successfully signed in");

        Get.offAllNamed('/main');
      } else {
        final decodedData = jsonDecode(response.body);
        _showAlertDialog('Error', decodedData['message'] ?? 'Login failed.');
      }
    } catch (e) {
      _showAlertDialog('Error', 'An error occurred. Please try again.');
      print('Error during login: $e');
    } finally {
      isLoading(false);
    }
  }

  void _showAlertDialog(String title, String message) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: 'OK',
      onConfirm: () {
        Get.back();
      },
    );
  }
}