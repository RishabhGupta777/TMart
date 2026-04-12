import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_showcase.dart';

class TBrandShowcaseList extends StatelessWidget {
  final String category;

  const TBrandShowcaseList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final products = snapshot.data!.docs;

        // Group products by brand
        Map<String, List<QueryDocumentSnapshot>> brandMap = {};
        for (var doc in products) {
          String brand = doc['brand'];
          brandMap.putIfAbsent(brand, () => []).add(doc);
        }

        // Create a list of brand showcases
        List<Widget> showcases = [];

        brandMap.forEach((brand, productList) {
            final firstDoc = productList.first;
            final brandLogo = firstDoc['brandLogo'];

            //  Extract images from variation[0], [1], and [2]
            List<String> images = [];

            for (var doc in productList) {
              final variations = doc['variation'] as List;

              for (int i = 0; i < variations.length && images.length < 3; i++) {
                final pic = variations[i]['pic'];
                if (pic != null && pic is String) {
                  images.add(pic);
                }
              }

              if (images.length >= 3) break; // stop if we already have 3 images
            }

            showcases.add(TBrandShowcase(
              images: images,
              brandName: brand,
              brandLogo: brandLogo,
            ));

        });

        // Return up to 2 (0–2) showcases
        return Column(children: showcases.take(2).toList());
      },
    );
  }
}
