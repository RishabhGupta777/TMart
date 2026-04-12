import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_card.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/sortable_products.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  final String brandName;
  final String brandLogo;
  final int totalItems;

  const BrandProducts({super.key,
    this.brandName=" ",
    this.brandLogo=" ",
    this.totalItems=4,
  });

  @override
  Widget build(BuildContext context) {
    Future<int> getBrandItemCount(String brandName) async {
      final snapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('brand', isEqualTo: brandName)
          .get();

      return snapshot.size;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(brandName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TBrandCard(showBorder: true, brandName: brandName,brandLogo: brandLogo,totalItems: totalItems,), // optional
            TSortableProducts(brandName: brandName), // pass to sortables
          ],
        ),
      ),
    );
  }
}
