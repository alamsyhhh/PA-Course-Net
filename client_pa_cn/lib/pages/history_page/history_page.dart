import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/history/history_controller.dart';
import '../products_pages/products_detail_page.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin<HistoryScreen> {
  final HistoryController historyController = Get.put(HistoryController());

  @override
  bool get wantKeepAlive => true; // Menandakan bahwa halaman ini ingin tetap aktif

  @override
  void initState() {
    super.initState();
    historyController.fetchHistory(); // Panggil metode fetchHistory() saat halaman diinisialisasi
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Penting untuk memanggil super.build(context)

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Obx(() {
        if (historyController.isLoading.value) {
          return _buildShimmerList();
        } else {
          return historyController.historyList.isEmpty
              ? _buildEmptyHistory()
              : ListView.builder(
            itemCount: historyController.historyList.length,
            itemBuilder: (context, index) {
              final history = historyController.historyList[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetailPage(productId: history['id']));
                },
                child: Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: history['imageUrl'] != null
                          ? NetworkImage(history['imageUrl'])
                          : NetworkImage('URL_DEFAULT_IMAGE'),
                    ),
                    title: Text(
                      history['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: history['createdBy'] != null
                        ? Text(
                      'Created By ${history['createdBy']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                        : Text(
                      'Created By Unknown',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey,
          child: ListTile(
            contentPadding: EdgeInsets.all(16.0),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
            ),
            title: Container(
              height: 20.0,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 16.0,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/empty-box.png', // Ganti dengan path gambar Anda
            width: 400, // Sesuaikan ukuran gambar
            height: 400,
          ),
          Text(
            'No history found',
            style: TextStyle(
              fontSize: 24, // Ubah ukuran teks sesuai kebutuhan
              fontWeight: FontWeight.bold, // Jadikan teks tebal
            ),
          ),
        ],
      ),
    );
  }
}
