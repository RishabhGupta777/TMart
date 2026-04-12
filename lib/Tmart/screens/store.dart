import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/controller/brand_service.dart';
import 'package:flashchat/TMart/screens/all_brand_screen.dart';
import 'package:flashchat/TMart/screens/brand_products.dart';
import 'package:flashchat/TMart/screens/cart_screen.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/cart_counter_icon.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/category_tab.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/search_icon_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/section_heading.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/brand_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/internet_provider.dart';
import '../widgets/base_scaffold.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BaseScaffold(
        appBar:AppBar(
          title: const Text('Store',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: TColors.primary),),
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TCartCounterIcon(
                iconColor: TColors.primary,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>CartScreen()));
                },
              ),
            ),
          ],
        ),
        body:  NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  pinned: true,  //<--isi se Tabbar pin hua h
                  snap: true,
                  expandedHeight: 340.0,
                  forceElevated: innerBoxIsScrolled,
                  flexibleSpace:ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const SearchIconContainer(showBorder: true,),
                      const SizedBox(height: 10,),
                       TSectionHeading(title:"Featured Brands",onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBrandScreen()));
                      }, ),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: getAllBrands(limit: 3), // limit to 2 brands
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Center(child: const CircularProgressIndicator());

                          final brands = snapshot.data!;
                          return TGridLayout(
                            itemCount: brands.length,
                            mainAxisExtent: 76,
                            itemBuilder: (_, index) {
                              final brand = brands[index];
                              return TBrandCard(
                                showBorder: true,
                                brandName: brand['name'],
                                brandLogo: brand['logo'],
                                totalItems: brand['totalItems'],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BrandProducts(
                                        brandName: brand['name'],
                                        brandLogo: brand['logo'],
                                        totalItems: brand['totalItems'],
                                      ),
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
                  bottom:  PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const TabBar(
                        isScrollable: true,
                        indicatorColor: TColors.primary,
                        unselectedLabelColor: Colors.grey,
                        labelColor: TColors.primary,
                        tabs: [
                          Tab(child: Text("Shoes")),
                          Tab(child: Text("Electronics")),
                          Tab(child: Text("Clothes")),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body:  TabBarView(
            children:[
              ///shoes category
             TCategoryTab(category: "Shoes"),
              ///Electronics category
              TCategoryTab(category: "Electronics",),
              ///Clothes category
              TCategoryTab(category: "Clothes",),

            ],
          ),
        ),

      ),
    );
  }
}

