import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerrWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 200.0,
        color: Colors.white,
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6, // Jumlah item shimmer yang ingin ditampilkan
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.all(10.0),
            elevation: 5,
            // color: Colors.yellow,
            child: ListTile(
              title: Container(
                width: double.infinity,
                height: 20.0,
                // color: Colors.yellow,
              ),
            ),
          ),
        );
      },
    );
  }
}