import 'package:flashchat/TMart/widgets/custom_shapes/brand_name.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/circular_icon.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_price_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_title_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';

class TProductCardHorizontal extends StatelessWidget {
  const TProductCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black12,
      ),
      child:Row(
          children: [
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          TRoundedContainer(
              height: 150,
              width: 150,
              radius: 15,
              child:Image(image:AssetImage("assets/images/Sneaker.png",),fit: BoxFit.contain,)),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
                padding:const EdgeInsets.symmetric(horizontal:3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.yellow,
                ),
                child: const Text('25%',style:TextStyle(fontWeight:FontWeight.w300))
            ),
          ),
          Positioned(
            top:2,
            right: 2,
            child: TCircularIcon(onTap:(){},icon: Icons.favorite,color: Colors.red,),
          ),
        ],
      ),
    ),
            Column(
              children: [
                SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(width:136,child: TProductTitleText(title: "White Nike Half sleeves Shoe",maxLines: 2,isLarge:false,)),
                    ),
                    SizedBox(height: 5,),
                    TBrandName(),
                  ],
                ),
                SizedBox(height:28,),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left:8),
                      child: TProductPriceText(price:"435",isLarge: false,),
                    ),
                    SizedBox(width: 47.5,),
                    Container(
                      decoration: const BoxDecoration(
                          color:Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                      ),
                      child: const SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(Icons.add,color: Colors.white,)),
                    ),
                  ],
                ),
              ],
            )
      ]
      )
    );
  }
}
