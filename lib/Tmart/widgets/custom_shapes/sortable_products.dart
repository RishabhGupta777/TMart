import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flashchat/TMart/widgets/product_card/product_card_vertical.dart';
import 'package:flutter/material.dart';

class TSortableProducts extends StatefulWidget {
  final String? brandName;
  final String? category;

  const TSortableProducts({super.key, this.brandName, this.category});

  @override
  State<TSortableProducts> createState() => _TSortableProductsState();
}

class _TSortableProductsState extends State<TSortableProducts> {
  String selectedSortOption = 'Name';

  Future<List<QueryDocumentSnapshot>> _fetchSortedProducts() async {

    Query collectionQuery = FirebaseFirestore.instance.collection('Products');

    // Filter by brand if brandName is provided
    if (widget.brandName != null && widget.brandName!.isNotEmpty) {
      collectionQuery = collectionQuery.where('brand', isEqualTo: widget.brandName);
    }

    //Filter by Category if Category is provided
    if (widget.category != null && widget.category!.isNotEmpty) {
      collectionQuery = collectionQuery.where('category', isEqualTo: widget.category);
    }


    final snapshot = await collectionQuery.get();
    final products = snapshot.docs;

    products.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;
      final bData = b.data() as Map<String, dynamic>;

      final aName = aData['name'] ?? '';
      final bName = bData['name'] ?? '';

      final aPrice = double.tryParse((aData['variation']?[0]['price'] ?? '0').toString().replaceAll(',', '')) ?? 0;
      final bPrice = double.tryParse((bData['variation']?[0]['price'] ?? '0').toString().replaceAll(',', '')) ?? 0;

      //this line also can written
      //final bPrice = double.parse(aData['variation'][0]['price'].toString().replaceAll(',', ''));
      ///double.tryParse() is a Dart method that tries to convert a String into a double
      ///and iss method me replaceAll price me ke sare comma(,) ko '' me convert kar dega like 1,34,999->134999 for suitable comparing

      switch (selectedSortOption) {
        case 'Name':
          return aName.compareTo(bName);
        case 'Higher to Lower Price':
          return bPrice.compareTo(aPrice); //→ High to Low  if b>a output=1
        case 'Lower to Higher Price':
          return aPrice.compareTo(bPrice); //->Low to High
        case 'Newest':
          return b.id.compareTo(a.id); // assuming ID is time-based
        default:
          return 0;
      }
    });

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Dropdown
        TRoundedContainer(
          height: 50,
          margin:9,
          radius: 12,
          showBorder: true,
          borderColor: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:12.0),
            child: Center(
              child: DropdownButtonFormField(
                decoration:  InputDecoration(
                  hintText:'Select  Categories',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                value: selectedSortOption,
                onChanged: (value) {
                  setState(() {
                    selectedSortOption = value!;
                  });
                },
                items: ['Name', 'Higher to Lower Price', 'Lower to Higher Price', 'Newest',]
                    .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ))
                    .toList(),
              ),
            ),
          ),
        ),

        /// Spacing
        const SizedBox(height:20),

        /// Products
        FutureBuilder<List<QueryDocumentSnapshot>>(
          future: _fetchSortedProducts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            final products = snapshot.data!;

            return TGridLayout(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];
                return TProductCardVertical(document: product);
              },
            );
          },
        ),

      ],
    );
  }
}
