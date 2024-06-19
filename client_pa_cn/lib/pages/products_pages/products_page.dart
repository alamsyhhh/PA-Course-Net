import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/product/products_controller.dart';
import '../../widgets/shimmer.dart';
import 'create_product_page.dart';
import 'products_detail_page.dart';

class ProductsPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final ProductsController productsController = Get.put(ProductsController());
  final TextEditingController searchController = TextEditingController();
  String lastSearchText = ''; // Variabel untuk menyimpan nilai teks terakhir

  ProductsPage({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    productsController.fetchProducts(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Obx(
        () => productsController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : productsController.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/empty-box.png', // Ganti dengan path gambar Anda
                          width: 400, // Sesuaikan ukuran gambar
                          height: 400,
                        ),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 24, // Ubah ukuran teks sesuai kebutuhan
                            fontWeight: FontWeight.bold, // Jadikan teks tebal
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by product name...',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                searchProducts('');
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          onChanged: (value) {
                            // Simpan nilai teks terbaru
                            lastSearchText = value;
                            // Jika input berubah, tunggu hingga pengguna selesai mengetik sebelum memulai pencarian
                            Future.delayed(Duration(seconds: 1), () {
                              if (value == lastSearchText) {
                                // Hanya mulai pencarian jika nilai teks saat ini sama dengan nilai terakhir yang disimpan
                                searchProducts(value);
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: productsController.products.length,
                          itemBuilder: (context, index) {
                            final product = productsController.products[index];
                            return ProductCard(product: product);
                          },
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CreateProductPage(categoryId: categoryId)),
          ).then((_) {
            productsController.fetchProducts(categoryId);
          });
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void searchProducts(String productName) {
    productsController.searchProducts(categoryId, productName);
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Get.to(() => ProductDetailPage(productId: product['id']));
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(imageUrl: product['imageUrl']),
              Text('${product['name']}',
                  style: TextStyle(fontSize: 22, color: Colors.black)),
              Text(
                'Quantity: ${product['qty']}',
                style: TextStyle(fontSize: 15, color: Colors.indigoAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImage extends StatefulWidget {
  final String imageUrl;

  ProductImage({required this.imageUrl});

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  late ValueNotifier<bool> _isImageLoadedNotifier;

  @override
  void initState() {
    super.initState();
    _isImageLoadedNotifier = ValueNotifier<bool>(false);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      precacheImage(NetworkImage(widget.imageUrl), context).then((_) {
        _isImageLoadedNotifier.value = true;
      });
    });
  }

  @override
  void dispose() {
    _isImageLoadedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isImageLoadedNotifier,
      builder: (context, isImageLoaded, _) {
        if (isImageLoaded) {
          return Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
          );
        } else {
          return ShimmerrWidget();
        }
      },
    );
  }
}
