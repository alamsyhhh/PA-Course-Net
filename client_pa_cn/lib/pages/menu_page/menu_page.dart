import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/menu/user_controller.dart';
import 'package:shimmer/shimmer.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return _buildShimmerMenu();
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                _buildProfileImage(userController.avatarPath.value),
                SizedBox(height: 20),
                Text(
                  userController.username.value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 130),
                ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context, userController);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, size: 24),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildShimmerMenu() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            _buildProfileImage(''), // Gunakan string kosong untuk shimmer
            SizedBox(height: 20),
            Container(
              height: 24, // Tinggi teks shimmer
              width: 150, // Lebar teks shimmer
              color: Colors.white, // Warna latar belakang teks shimmer
            ),
            SizedBox(height: 130),
            ElevatedButton(
              onPressed: () {},
              // Jangan lakukan apa pun ketika tombol di-shimmer
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 24, color: Colors.grey[300]),
                  SizedBox(width: 8),
                  Container(
                    height: 24,
                    width: 80,
                    color: Colors
                        .white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    return CircleAvatar(
      backgroundImage: imageUrl.isNotEmpty
          ? NetworkImage(imageUrl)
          : null,
      radius: 80,
    );
  }

  void _showLogoutDialog(BuildContext context, UserController userController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                userController.logout();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
