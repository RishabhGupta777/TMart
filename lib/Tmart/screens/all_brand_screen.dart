import 'package:flashchat/TMart/controller/brand_service.dart';
import 'package:flashchat/TMart/screens/brand_products.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_card.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/section_heading.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flutter/material.dart';

class AllBrandScreen extends StatefulWidget {
  const AllBrandScreen({super.key});


  @override
  State<AllBrandScreen> createState() => _AllBrandScreenState();
}

class _AllBrandScreenState extends State<AllBrandScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Heading
            const TSectionHeading(title: 'Brands', showActionButton: false),
            const SizedBox(height:10),

            /// Brands
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getAllBrands(),
              builder: (context, snapshot){
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final brands = snapshot.data!;
                return TGridLayout(
                  itemCount:brands.length,
                  mainAxisExtent: 80,
                  itemBuilder: (_, index) {
                    final brand = brands[index];
                    return TBrandCard(
                      showBorder: true,
                      brandName: brand['name'],
                      brandLogo: brand['logo'],
                      totalItems: brand['totalItems'],
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrandProducts(brandName: brand['name'],brandLogo:brand['logo'],totalItems: brand['totalItems'],),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )

          ],
        ),
      ),
    );
  }
}
