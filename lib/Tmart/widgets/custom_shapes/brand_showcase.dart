import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/screens/brand_products.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_card.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';

class TBrandShowcase extends StatefulWidget {
  final List<String> images;
  final String brandName;
  final String brandLogo;

  const TBrandShowcase({
    super.key,
    required this.images,
    required this.brandName,
    required this.brandLogo,
  });

  @override
  State<TBrandShowcase> createState() => _TBrandShowcaseState();
}

class _TBrandShowcaseState extends State<TBrandShowcase> {
  int productCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchBrandProductCount();
  }

  Future<void> _fetchBrandProductCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('brand', isEqualTo: widget.brandName)
        .get();

    setState(() {
      productCount = snapshot.size;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BrandProducts(
          brandName: widget.brandName,
          brandLogo: widget.brandLogo,
          totalItems: productCount,
        )));
      },
      child: TRoundedContainer(
        showBorder: true,
        borderColor: Colors.black45,
        margin:8,
        backgroundColor: Colors.white,
        child:Column(
          children: [
            TBrandCard(
              showBorder: false,
              brandName: widget.brandName,
              brandLogo: widget.brandLogo,
              totalItems:productCount,
            ),
            Row(
                children: widget.images.map((image)=>BrandTopImagesWidget(image,context)).toList()
            )
          ],
        ),

      ),
    );
  }

  Expanded BrandTopImagesWidget(String image,context) {
    return Expanded(
      child: TRoundedContainer(
        radius: 0,
        borderColor: Colors.white,
        height: 80,
        margin:10,
        child:Image.network(image, fit: BoxFit.contain),
      ),
    );
  }
}
