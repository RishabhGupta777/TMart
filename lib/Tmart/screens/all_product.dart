import 'package:flashchat/TMart/widgets/custom_shapes/sortable_products.dart';
import 'package:flutter/material.dart';

class AllProduct extends StatefulWidget {
  final String ? category;

  const AllProduct({super.key,this.category});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Popular Products'),
      ),
      body: SingleChildScrollView(
        child: TSortableProducts(category: widget.category),
      ),
    );
  }
}

