import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/screens/all_product.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brandShowcaseList.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_showcase.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/section_heading.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/product_card/product_card_vertical.dart';

class TCategoryTab extends StatelessWidget {
  final String category;
  const TCategoryTab({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(   //yha Listview bhi rah sakta tha  ,the shrinkWrap=true , the physics
      child: Column(
        children: [
          const SizedBox(height:65,),
          TBrandShowcaseList(category: category), //  Dynamic Showcase
          const SizedBox(height: 4,),
          TSectionHeading(title: 'You might like', onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder:(context)=>AllProduct(category: category,))),),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Products')
                .where('category', isEqualTo: category)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

              final products = snapshot.data!.docs;

              return TGridLayout(
                itemCount: products.length,
                itemBuilder: (_, int index) {
                  final product = products[index];
                  return TProductCardVertical(document: product);
                },
              );
            },
          ),
          const SizedBox(height: 4,),
        ],
      ),
    );
  }
}

