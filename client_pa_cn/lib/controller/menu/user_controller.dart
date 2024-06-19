import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../pages/auth_pages/login_page.dart';
import '../../../data/config.dart';

class UserController extends GetxController {
  var username = ''.obs;
  var avatarPath = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.offAll(() => LoginScreen());
        return;
      }

      final response = await http.get(
        Uri.parse('$apiUrl/users/current-user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        username(data['username']);
        avatarPath(data['avatarPath']);
      } else {
        Get.snackbar('Error', 'Failed to fetch user profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user profile');
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAll(() => LoginScreen());
  }
}
