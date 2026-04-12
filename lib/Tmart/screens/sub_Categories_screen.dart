import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/section_heading.dart';
import 'package:flashchat/TMart/widgets/product_card/product_card_horizonatal.dart';
import 'package:flutter/material.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sports'),
        ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            ///Banner
            TRoundedContainer(
              width: double.infinity,
              radius: 12,
              margin:8,
              child: Image.asset('assets/images/banner1.png',fit: BoxFit.contain,),
            ),
            SizedBox(height: 20,),

            ///SubCategories
            Column(
              children: [
                TSectionHeading(title: 'Sports shirts',onPressed: (){},showActionButton:true),
                SizedBox(height: 10,),
                SizedBox(
                  height: 181,
                  child: ListView.separated(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder:(_,__)=>SizedBox(width: 6,),
                      itemBuilder:(_,index)=> TProductCardHorizontal()),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
