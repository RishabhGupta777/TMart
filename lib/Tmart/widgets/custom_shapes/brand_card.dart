import 'package:flashchat/TMart/widgets/custom_shapes/brand_name.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';

class TBrandCard extends StatelessWidget {
  const TBrandCard({
    super.key,
    this.brandName=" ",
    this.brandLogo=" ",
    required this.showBorder,
    this.onTap,
    this.totalItems=256,
  });
  final String brandName;
  final String brandLogo;
  final bool showBorder;
  final Function() ? onTap;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(
        showBorder: showBorder,
        borderColor: Colors.black26,
        margin:8,
        width: double.infinity,  //yha 56 tha
        height: 60,
        padding: 6.0,
        radius: 20,
        backgroundColor: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width:60,
                height: 60,
                child:Image.network(brandLogo, height: 40, width: 40),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TBrandName(title: brandName,),
                SizedBox(
                    width:86 ,
                    child: Text("$totalItems products",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black26),))
              ],
            )
          ],
        ),
      ),
    );
  }
}
