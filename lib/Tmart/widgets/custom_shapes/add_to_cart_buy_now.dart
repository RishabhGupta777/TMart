import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/screens/cart_screen.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/screens/check_out_screen.dart';


class TAddToCartBuyNow extends StatefulWidget {

  final DocumentSnapshot ? document;
  final int selectedVariationIndex;
  final String attValue;
  const TAddToCartBuyNow({
    super.key,
    this.document,
    this.selectedVariationIndex=0,
    required this.attValue
  });

  @override
  State<TAddToCartBuyNow> createState() => _TAddToCartBuyNowState();
}

class _TAddToCartBuyNowState extends State<TAddToCartBuyNow> {
  static final _userId = FirebaseAuth.instance.currentUser?.email;
  String attributeName = "";


  bool isCartListed=false;
  @override
  void initState() {
    super.initState();
    checkIfCartListed();
  }
  // Check if the item is in the cart
  Future<void> checkIfCartListed() async {
    final variationId = '${widget.document!.id}_${widget.selectedVariationIndex}';
    if (_userId == null || widget.document == null) return; // null check for user and document

    final doc = await FirebaseFirestore.instance
        .collection('cartlists')
        .doc(_userId)
        .collection('items')
        .doc(variationId)
        .get();

    if (doc.exists) {
      setState(() {
        isCartListed = true;
      });
    }


  }

  // Toggle the item between cart and wishlist
  Future<void> toggleCartList() async {
    if (_userId == null || widget.document == null) return;

    final variationId = '${widget.document!.id}_${widget.selectedVariationIndex}';
    final itemRef = FirebaseFirestore.instance
        .collection('cartlists')
        .doc(_userId)
        .collection('items')
        .doc(variationId);

    if (!isCartListed && widget.attValue.trim().isNotEmpty) {
      final data = widget.document!.data() as Map<String, dynamic>;
      final variationData = data['variation'][widget.selectedVariationIndex];

      await itemRef.set({
        'productId': widget.document!.id,
        'variationIndex': widget.selectedVariationIndex,
        'category': data['category'],
        'name': data['name'],
        'brand':data['brand'],
        'quantity': 1,
        'variation': variationData,
        'attValue':widget.attValue,
        'attributeName':attributeName,
      });

      setState(() {
        isCartListed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added to cart successfully')),
      );
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please choose the $attributeName')),);
    }
  }


  @override
  Widget build(BuildContext context) {
    final data = widget.document!.data() as Map<String, dynamic>;
    final attributes = List<Map<String, dynamic>>.from(data['attribute'] ?? []);
    final Map<String, dynamic> attribute = attributes[0];
    attributeName=attribute['name'] ?? " ";

    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TButton(onTap: (){
            isCartListed ? Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen())) : toggleCartList();
            },
              radius: 0.0,
              width:double.infinity,
              height:60,
              text:isCartListed ?'Go to cart ' : 'Add to cart' ,
              backgroundColor: Colors.white,
              textColor: Colors.black,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: TButton(
              radius: 0.0,
              width:double.infinity ,
              height:60,
              onTap:(){
                final data = widget.document!.data() as Map<String, dynamic>;
                final variations = List<Map<String, dynamic>>.from(data['variation'] ?? []);
                final selectedPrice = variations[widget.selectedVariationIndex]['price'];
                final totalPrice = double.tryParse(selectedPrice.toString()) ?? 0.0;
                if(widget.attValue!=" "){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Checkoutscreen(
                totalPrice: totalPrice,
                singleProduct: widget.document,
                selectedVariationIndex: widget.selectedVariationIndex,
                attributeName:attributeName,
                attValue:widget.attValue,
              )));} else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please choose the $attributeName')),);
                }
            },
              text:'Buy now',
            ),
          ),
        ],
      ),
    );
  }
}
