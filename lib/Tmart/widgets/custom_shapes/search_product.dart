import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flashchat/TMart/widgets/product_card/product_card_vertical.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({
    super.key,
  });

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final textEditingController = TextEditingController();
  String searchQuery='' ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        titleSpacing: 0,
        title:  Padding(
          padding: const EdgeInsets.symmetric(horizontal:18.0),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              filled: true, // Enable background color
              fillColor: Colors.white, // Change background color inside border
              prefixIcon:const Icon(Icons.search,size:30,color:TColors.primary,),
              hintText: 'Search to Store',
              hintStyle: TextStyle(color: Colors.black54),
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
            ),
            onChanged: (value){
              setState(() {
                searchQuery= value.toLowerCase(); // Convert to lowercase for case-insensitive search;
                //value to search User
              });
            },
          ),
        ),
      ),
      body:StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Products').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const
               Center(child: CircularProgressIndicator(backgroundColor: Colors.lightBlueAccent,),
              );
            }
            // final products = (snapshot.data!).docs;
            // for (var product in products) {
            //   final nameFromDatabase = product['name'];
            //
            //   List<dynamic> filteredProducts = [];
            //   // Filter users based on search input
            //   if (searchQuery.isNotEmpty && // Ensure searchQuery is not empty-->Now, the users will only appear when the search bar has input.
            //       nameFromDatabase.toLowerCase().contains(searchQuery)) {
            //      filteredProducts.add(nameFromDatabase);
            //   }
            final allProducts = snapshot.data!.docs;

            // If no search input, return an empty widget or message
            if (searchQuery.isEmpty) {
              return const Center(
                child: Text(
                  'Start typing to search for products...',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

             final filteredProducts = allProducts.where((product) {
               return product['name'].toString().toLowerCase().contains(searchQuery);
                     }).toList();

            if (filteredProducts.isEmpty) {
              return const Center(
                child: Text(
                  'No matching products found.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

            return TGridLayout(
              itemCount: filteredProducts.length,
              itemBuilder: (_, index) {
                final product = filteredProducts[index];
                return TProductCardVertical(document: product);
              },
            );

          })
    );
  }
}

