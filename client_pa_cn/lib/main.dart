import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:client_pa_cn/pages/home_page.dart';
import 'package:client_pa_cn/pages/auth_pages/login_page.dart';
import 'package:client_pa_cn/pages/menu_page/menu_page.dart';
import 'package:client_pa_cn/pages/products_pages/products_detail_page.dart';
import 'package:client_pa_cn/pages/products_pages/products_page.dart';
import 'package:client_pa_cn/pages/auth_pages/register_page.dart';
import 'package:client_pa_cn/pages/splash_screen_page.dart';
import 'package:client_pa_cn/pages/main_page.dart';

void main() async {
  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen(
          child: LoginScreen(),
          lottieUrl: 'https://lottie.host/87f13f4d-1435-4454-ae4d-33d831f688b2/95vbhGRbrm.json',
        )),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/main', page: () => MainScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),

        GetPage(name: '/product', page: () {
          var args = Get.arguments;
          return ProductsPage(
            categoryId: args['categoryId'],
            categoryName: args['categoryName'],
          );
        }),
        GetPage(name: '/detail-product', page: () {
          var args = Get.arguments;
          return ProductDetailPage(productId: args['productId']);
        }),
      ],
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('id', ''),
      ],
    );
  }
}
