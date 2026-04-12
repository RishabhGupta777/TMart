import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/controller/wishlist_provider.dart';
import 'package:flashchat/TMart/discount.dart';
import 'package:flashchat/TMart/screens/product_detail.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_name.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/circular_icon.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_price_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_title_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TProductCardVertical extends StatefulWidget {
  const TProductCardVertical({
    super.key,
   this.document,
  });
  final DocumentSnapshot ? document;

  @override
  State<TProductCardVertical> createState() => _TProductCardVerticalState();
}

class _TProductCardVerticalState extends State<TProductCardVertical> {

  int discount=0;

  @override
  void initState() {
    super.initState();
    context.read<WishlistProvider>().checkIfWishlisted(widget.document!.id);
  }

  @override
  Widget build(BuildContext context) {

    final data = widget.document!.data() as Map<String, dynamic>;
    final name = data['name'] ?? '';
    final brand = data['brand'] ?? '';

    final variations = List<Map<String, dynamic>>.from(data['variation'] ?? []);
    final variation = variations[0];
    final imageUrl=variation['pic'];
    final price=variation['price'];
    final realprice=variation['realprice'];

    setState(() {
      discount = calculateDiscount(realprice,price);
    });

    return GestureDetector(
      onTap: (){
        Navigator.push( context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              document : widget.document!
            ),
          ),);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black12,
          border: Border.all( // ✅ White border
            color: Colors.white,
          ),
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  TRoundedContainer(
                    height: 150,
                    width: 150,
                    radius: 15,
                    child: Image.network(imageUrl, height: 100, fit: BoxFit.cover),),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                        padding:const EdgeInsets.symmetric(horizontal:3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.yellow,
                        ),
                        child: Text('${discount.toString()}%',style:TextStyle(fontWeight:FontWeight.w300))
                    ),
                  ),
                  Positioned(
                    top:2,
                    right: 2,
                    child: Consumer<WishlistProvider>(
                      builder: (context,provider,_) {
                        final wishlisted = provider.isWishlisted(widget.document!.id);
                        return TCircularIcon(
                          onTap: ()async{
                            await provider.toggleWishlist(widget.document!);
                          },
                          icon: wishlisted ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title:name,isLarge:false,),
                  SizedBox(height: 5,),
                  TBrandName(title: brand,),
                  SizedBox(height: 5,),
                  TProductPriceText(price:price,isLarge: false,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





