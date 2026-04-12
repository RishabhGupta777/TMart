import 'package:flashchat/TMart/controller/wishlist_provider.dart';
import 'package:flashchat/TMart/screens/home.dart';
import 'package:flashchat/TMart/widgets/product_card/grid_layout.dart';
import 'package:flashchat/TMart/widgets/product_card/product_card_vertical.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<WishlistProvider>().getInitialWishlist();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:const Text('Wishlist',style: TextStyle(fontSize:20,fontWeight: FontWeight.w800),),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>const Home(),
                ),
              );
            },
            icon: const Icon(Icons.add),),
        ],
      ),
      body:Consumer<WishlistProvider>(
        builder: (context, provider, child){
          final wishlistDocs = provider.getWishlists(); //similar as List<Map<String,dynamics>>wishlistDocs=provider.getNotes();
          return wishlistDocs.isEmpty
              ? const Center(
            child: Text('Your wishlist is empty!'),
          )
              :  SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
              children: [
              TGridLayout( itemCount: wishlistDocs.length,
              itemBuilder: (_,int index)=>TProductCardVertical(document:wishlistDocs[index])),
              ],
              )
              );
        },
      )
    );
  }
}
