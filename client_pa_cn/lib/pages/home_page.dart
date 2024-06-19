import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product/home_controller.dart';
import '../widgets/shimmer.dart';
import 'products_pages/products_page.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    homeController.fetchCategories();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product Inventory'),
        backgroundColor: Colors.white10,
      ),
      body: HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => homeController.isLoading.value
          ? ShimmerWidget()
          : ListView.builder(
        itemCount: homeController.categories.length,
        itemBuilder: (context, index) {
          final category = homeController.categories[index];
          return Card(
            margin: EdgeInsets.all(10.0),
            elevation: 5,
            child: ListTile(
              title: Text(category['name']),
              onTap: () {
                Get.to(() => ProductsPage(
                  categoryId: category['id'],
                  categoryName: category['name'],
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
