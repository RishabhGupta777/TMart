
import 'package:flutter/material.dart';

class TGridLayout extends StatelessWidget {
  const TGridLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mainAxisExtent=275,  //275 tha
    this.crossAxisCount = 2,
  });
  final int itemCount;
  final Widget? Function(BuildContext,int) itemBuilder;
  final double ? mainAxisExtent;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount:itemCount,
      shrinkWrap: true,  //it occupies only the space which currently the space of the children of this GridView
      padding: const EdgeInsets.only(top:0.0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: mainAxisExtent ,  // VVI--> ye na rahe to card ke height me overflow ane lagega due to
        //for gridview a max height is fix for card and mainAxisExent increase it
      ),
       itemBuilder: itemBuilder
    );
  }
}
