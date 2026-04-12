import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/screens/product_reviews.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/add_to_cart_buy_now.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_attributes.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_image_slider.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_meta_data.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rating_and_share.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/section_heading.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/text_read_more.dart';
import 'package:flutter/material.dart';


class ProductDetailScreen extends StatefulWidget {

  final DocumentSnapshot  document;
  final int selectedVariationIndex;
  const ProductDetailScreen({super.key,required this.document,this.selectedVariationIndex=0});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedVariationIndex=0;
  String attributeValue=" ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///For changing the selected image when data comes from Add to cart
    setState(() {
      selectedVariationIndex = widget.selectedVariationIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.document.data() as Map<String, dynamic>;

    ///Image management
    final variations = List<Map<String, dynamic>>.from(data['variation'] ?? []);
    final images = variations.map((v) => v['pic'] as String).toList();  // for slider
    final prices = variations.map((v) => v['price'].toString()).toList();  // or 'name' if you have it
    final realprices = variations.map((v) => v['realprice'].toString()).toList();  // or 'name' if you have it

    ///MetaData management
    final name = data['name'] ?? '';
    final brand = data['brand'] ?? '';
    final price = prices[selectedVariationIndex]; // get current price
    final realprice = realprices[selectedVariationIndex];
    final brandLogo = data['brandLogo'] ?? '';

    ///Attributes Management
    final attributes = List<Map<String, dynamic>>.from(data['attribute'] ?? []);

    ///Rating and Reviews
    final totalReviews = data['totalReviews'] ?? 0;
    final totalRating = (data['totalRating'] ?? 5).toDouble();


    return Scaffold(
        bottomNavigationBar: SafeArea(
          top: false, // Prevents extra space at the top
          child: TAddToCartBuyNow(
              document:widget.document,
              selectedVariationIndex :selectedVariationIndex,
            attValue:attributeValue
          ),
        ),
      body:SingleChildScrollView(
        child:Column(
          children: [
            ///product image slider
            TProductImageSlider(
             onImageChange: (index) {
                     setState(() {
                     selectedVariationIndex = index;
                   });
               },
              images: images,document:widget.document,selectedVariationIndex:selectedVariationIndex),

            ///Rating and Share button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  TRatingAndShare( totalReviews : totalReviews , totalRating: totalRating ),
                  
                  TProductMetaData(
                    brand: brand,
                    name:name,
                    realprice:realprice,
                    price:price,
                    brandLogo:brandLogo,
                  ),

                  ProductAttributes(
                      attributes: attributes,
                      onAttributeSelected: (attValue){
                        setState(() {
                          attributeValue = attValue;
                        });
                      },
                  ),
                  SizedBox(height: 8,),

                  TSectionHeading(title: 'Discription' ,showActionButton: false,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextReadMore(
                      text:'This is a Product description for Blue Nike Sleeve less vest.There are more things that can be added but i am unable to add then due to lack of space     ',
                    ),
                  ),

                  ///Reviews
                  Divider(),
                  InkWell(
                    onTap:()=>  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductReviewsScreen(document:widget.document,))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TSectionHeading(title: 'Reviews (${totalReviews.toString()})',showActionButton: false,),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),

          ],
        ),
      )
    );
  }
}


