import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/TMart/screens/check_out_screen.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/cart_items.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    final userId = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart',style: TextStyle(fontSize:20,fontWeight: FontWeight.w800)),
      ),
      body:TCartItems(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('cartlists')
                  .doc(userId)
                  .collection('items')
                  .snapshots(),
          builder: (context, snapshot) {
                       if (snapshot.connectionState == ConnectionState.waiting) {
                         return Text('Loading...');
                       }

                       final cartDocs = snapshot.data?.docs ?? [];

                       // Calculate total
                           totalPrice = 0.0;
                for (var doc in cartDocs) {
                     final data = doc.data() as Map<String, dynamic>;
                     final quantity = data['quantity'] ?? 1;
                    double price = 0.0;
                     final variation = data['variation'];
                     if (variation is List && variation.isNotEmpty) {
                       final firstVar = variation.first as Map<String, dynamic>;
                       price = double.tryParse(firstVar['price'].toString()) ?? 0.0;
                     } else if (variation is Map<String, dynamic>) {
                       price = double.tryParse(variation['price'].toString()) ?? 0.0;
                     }
                     totalPrice += price * quantity;
                }
                return SizedBox(
                  width: 171,
                    child: Text('₹${totalPrice.toStringAsFixed(2)}',style: TextStyle(fontWeight:FontWeight.w500,fontSize: 25),));
          }),
            TButton(onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Checkoutscreen(totalPrice: totalPrice,),));
            },height:40,width:170,radius :8,text:'Place Order',),
          ],
        ),
      ),
    );
  }
}


