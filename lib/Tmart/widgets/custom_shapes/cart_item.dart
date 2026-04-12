import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/TMart/screens/product_detail.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_name.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_price_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_quantity_with_add_remove_button.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_title_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';

class TCartItem extends StatefulWidget {
  final DocumentSnapshot ? document;
  final int ? variationIndex;
  final bool removeAndQuantity;
  final String attValue;
  final String attributeName;
  final bool isSingleProduct;
  const TCartItem({
    super.key,
    this.document,
    required this.removeAndQuantity,
    this.variationIndex,
    this.attValue='',
    this.attributeName='',
    this.isSingleProduct=false,
  });

  @override
  State<TCartItem> createState() => _TCartItemState();
}

class _TCartItemState extends State<TCartItem> {
  @override
  Widget build(BuildContext context) {
    final data = widget.document!.data() as Map<String, dynamic>;
    final selectedVariationIndex = data['variationIndex'];
    final name = data['name'] ?? '';
    final brand = data['brand'] ?? '';
    final quantity = data['quantity'] ?? 1;
    final attributeName=data['attributeName'] ?? '';
    final attValue = data['attValue'] ?? '';


    Map<String, dynamic> variation = {};
    if (widget.variationIndex != null) {
      final variations = List<Map<String, dynamic>>.from(data['variation'] ?? []);
      if (widget.variationIndex! < variations.length) {
        variation = variations[widget.variationIndex!];
      }
    } else {
      variation = data['variation'] as Map<String, dynamic>? ?? {};
    }

    final imageUrl=variation['pic'];
    final price=variation['price'];

    ///for total price of individual items
    final unitPrice = double.tryParse(price.toString()) ?? 0.0;
    final totalItemPrice = unitPrice * quantity;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
                  onTap: ()async{
          final productId = data['productId'];
             if (productId != null && productId != '') {
             final productDoc = await FirebaseFirestore.instance
                                 .collection('Products')
                                  .doc(productId)
                                  .get();

          if (productDoc.exists) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(document: productDoc,selectedVariationIndex:selectedVariationIndex,),
              ),
            );
          }}},
            child: Container(
                width: double.infinity,
                height:120,
                decoration: BoxDecoration(
                  color: Colors.black12,
                ),
                child:Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TRoundedContainer(
                            height: 100,
                            width: 100,
                            radius: 15,
                            child:Image.network(imageUrl, height: 100, fit: BoxFit.cover,),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0,top:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                  width:136,
                                  child: TProductTitleText(title:name,isLarge:false,),),
                            ),
                            SizedBox(height: 3,),
                            TBrandName(title: brand,),
                            SizedBox(height: 3,),
                            if(attributeName!='')Text('$attributeName : $attValue',style: TextStyle(color: Colors.black54),),
                            if(widget.isSingleProduct==true)Text('${widget.attributeName} : ${widget.attValue}',style: TextStyle(color: Colors.black54),) ,
                            if(attributeName!='')SizedBox(height:3,),
                            TProductPriceText(price:totalItemPrice.toStringAsFixed(2),isLarge: false,),
                          ],
                        ),
                      )
                    ]
                )
            ),
          ),
         if(widget.removeAndQuantity) Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color:Colors.black12,
              // borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 116,
                  decoration: BoxDecoration(
                    color:Colors.black12,
                    // borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap:(){
                      FirebaseFirestore.instance
                          .collection('cartlists')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .collection('items')
                          .doc(widget.document!.id)
                          .delete();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline,color: Colors.black,),
                        SizedBox(width: 5,),
                        Text('remove',style:TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TProductQuantityWithAddRemoveButton(
                    initialQuantity: quantity,
                    onQuantityChanged: (newQuantity) {
                      FirebaseFirestore.instance
                          .collection('cartlists')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .collection('items')
                          .doc(widget.document!.id)
                          .update({'quantity': newQuantity});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
