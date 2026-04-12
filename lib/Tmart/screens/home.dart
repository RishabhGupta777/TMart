import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/controller/all_product_provider.dart';
import 'package:flashchat/TMart/controller/internet_provider.dart';
import 'package:flashchat/TMart/screens/all_product.dart';
import 'package:flashchat/TMart/screens/cart_screen.dart';
import 'package:flashchat/TMart/widgets/base_scaffold.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/Vertical_image_text.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/banner_slider.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/cart_counter_icon.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/search_icon_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/section_heading.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flashchat/TMart/widgets/product_card/product_card_vertical.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {

  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    categories=context.watch<AllProductProvider>().getAllCategories();
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: TColors.primary,
              padding: const EdgeInsets.all(0),
              child:SizedBox(
                height:310,
                child: Stack(  //this Widget allow stack elements on top of each other
                  children: [
                    Positioned(top:-150,right:-250,child: TRoundedContainer(height:400,width:400,radius:400,backgroundColor: TColors.textWhite.withOpacity(0.1),)),
                    Positioned(top:100,right:-300,child: TRoundedContainer(height:400,width:400,radius:400,backgroundColor: TColors.textWhite.withOpacity(0.1),)),
                    Positioned(
                      top: 2,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        title: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Good day for shoping",style: TextStyle(fontSize: 14,color: Colors.white),),
                            Text("Rishabh Gupta",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)
                          ],
                        ),
                        backgroundColor: TColors.primary.withOpacity(0.0),
                        elevation: 0,
                        actions: [
                          TCartCounterIcon(onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder:(context)=>CartScreen()));
                          }),
                          SizedBox(width: 10,)
                        ],
                      ),
                    ),
                    const Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: SearchIconContainer(),
                    ),
                    Positioned(
                      top: 180,
                      left: 0,
                      right: 0,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left:15.0),
                            child: Text('Popular Categories',style:TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.white)),
                          ),
                          const SizedBox(height:10),
                         SizedBox(
                           height:82,
                           child: ListView.builder(
                             scrollDirection: Axis.horizontal,
                             shrinkWrap: true,
                             itemCount: categories.length,
                             itemBuilder: (BuildContext context, int index) {
                               final category = categories[index];
                               return TVerticalImageText(
                                 name:category['name'],
                                 imageUrl:category['pic'],
                                 onTap:()=> Navigator.push(context, MaterialPageRoute(builder:(context)=>AllProduct(category:category['name'],))),);
                                       ///yha par subCategory name ke file me pass karwaya tha video me
                             }
                           ),
                         ),
                        ],
                      )

                  )
                  ],
                ),
              ),
            ),
            const BannerSlider(),
          SizedBox(height: 2,),
          TSectionHeading(title: 'Popular Products', onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder:(context)=>AllProduct())),),
          Consumer<AllProductProvider>(
        builder: (context, provider,_) {
      final products = provider.getAllProducts();
      return products.isEmpty
          ? const Center(child: Text('No Products yet!'),) : TGridLayout(
        itemCount: products.length,
        itemBuilder: (_, int index) {
          final product = products[index];
          return TProductCardVertical(
            document: product,
          );
        },
      );
    }
    )
          ],
        ),
      ),
    );
  }
}

