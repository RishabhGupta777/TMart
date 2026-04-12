import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/cart_item.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,
    this.removeAndQuantity = true,
  });
  final bool removeAndQuantity;


  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.email;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cartlists')
            .doc(userId)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartlistDocs = snapshot.data?.docs ?? [];

          if (cartlistDocs.isEmpty) {
            return const Center(child: Text('Your Cart is empty.'));
          }

          return ListView.builder(
              itemCount: cartlistDocs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (_,int index)=>TCartItem(document: cartlistDocs[index],removeAndQuantity:removeAndQuantity));
        }
    );
  }
}