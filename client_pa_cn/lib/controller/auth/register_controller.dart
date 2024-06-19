import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../data/config.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var avatar = Rxn<File>();
  var isLoading = false.obs;
  String? avatarMimeType;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      avatar.value = File(pickedFile.path);
      avatarMimeType = lookupMimeType(pickedFile.path);
      print('Selected file MIME type: $avatarMimeType');
    } else {
      print('No image selected.');
    }
  }

  Future<void> register() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        avatar.value == null) {
      _showAlertDialog('Error', 'Please fill in all fields and select an image.');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showAlertDialog('Error', 'Passwords do not match.');
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse('$apiUrl/users/register');
      final request = http.MultipartRequest('POST', url);
      request.fields['username'] = usernameController.text;
      request.fields['password'] = passwordController.text;

      if (avatar.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          avatar.value!.path,
          contentType: MediaType.parse(avatarMimeType ?? 'image/jpeg'),
        ));
      }

      request.headers['Content-Type'] = 'multipart/form-data';

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);

      print('Sending request to $url');
      print('Request fields: ${request.fields}');
      print('Request files: ${request.files}');

      final streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _showAlertDialog('Success', decodedData['message'], success: true);
      } else {
        _showAlertDialog('Error', decodedData['message']);
      }
    } catch (e) {
      _showAlertDialog('Error', 'An error occurred. Please try again.');
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showAlertDialog(String title, String message, {bool success = false}) {
    Get.defaultDialog(
      title: title,
      content: Text(message),
      textConfirm: 'OK',
      onConfirm: () {
        Get.back();
        if (success) {
          Get.offAllNamed('/login');
        }
      },
    );
  }
}
