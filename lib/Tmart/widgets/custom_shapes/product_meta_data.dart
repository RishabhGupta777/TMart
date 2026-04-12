import 'package:flashchat/TMart/discount.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_title_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/product_price_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_name.dart';

class TProductMetaData extends StatefulWidget {
  const TProductMetaData({
    super.key,
   required this.name,
   required this.price,
   required this.brand,
    required this.brandLogo,
    required this.realprice,

  });
  final String name;
  final String  price;
  final String  realprice;
  final String  brand;
  final String  brandLogo;

  @override
  State<TProductMetaData> createState() => _TProductMetaDataState();
}

class _TProductMetaDataState extends State<TProductMetaData> {
  int discount=0;

  @override
  Widget build(BuildContext context) {
    setState(() {    ///jab jab ye class build hogi tab calculateDiscount calculate hoga and reset the discount
      discount = calculateDiscount(widget.realprice, widget.price);
    });


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TRoundedContainer(
              backgroundColor: Colors.amber,
              padding: 6,
              radius: 10,
              child: Text('${discount.toString()}%',style: Theme.of(context).textTheme.labelLarge!,),
            ),
            SizedBox(width: 10),
            Text('₹${widget.realprice}',style: Theme.of(context).textTheme.titleSmall!.apply(decoration:TextDecoration.lineThrough),),
            SizedBox(width: 10),
            TProductPriceText(price: widget.price),
          ],
        ),
        SizedBox(height: 5),

        ///Title
        TProductTitleText(
            isLarge: false,
            title: widget.name,
        ),
        SizedBox(height: 5),

        ///Stock Status
        Row(
          children: [
            Text('Status'),
            SizedBox(width:8),
            TProductTitleText(isLarge: false, title: 'In Stock'),
          ],
        ),
        SizedBox(height: 5),
        ///Brand
        Row(
          children: [
            TRoundedContainer(
              height: 30,
              radius:0,
              child:Image.network(
                widget.brandLogo,
                fit: BoxFit.cover, // Ensures it fills the rounded shape properly
              ),
            ),
            SizedBox(width: 2,),
            TBrandName(title: widget.brand),
          ],
        ),

      ],
    );
  }
}

