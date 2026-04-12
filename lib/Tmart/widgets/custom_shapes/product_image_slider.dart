import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/TMart/controller/wishlist_provider.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/circular_icon.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';


class TProductImageSlider extends StatefulWidget {
  const TProductImageSlider({
    super.key,
   required this.images,
    this.document,
    required this.onImageChange,
    this.selectedVariationIndex=0,
  });
  final int selectedVariationIndex;
  final List images;
  final DocumentSnapshot ? document;
  final Function(int index) onImageChange;

  @override
  State<TProductImageSlider> createState() => _TProductImageSliderState();
}

class _TProductImageSliderState extends State<TProductImageSlider> {
  int selectedImageIndex = 0;


  @override
  void initState() {
    super.initState();
    // Assume you pass productId and document to this widget
    context.read<WishlistProvider>().checkIfWishlisted(widget.document!.id);
    ///For changing the selected image when data comes from Add to cart
    setState(() {
      selectedImageIndex=widget.selectedVariationIndex;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context,provider,_) {
        final wishlisted = provider.isWishlisted(widget.document!.id);
        return Column(
          children: [
            SizedBox(height:28),
            TRoundedContainer(
              margin: 6,
              borderColor: Colors.white,
              child: Stack(
                children: [
                  SizedBox(
                    height: 350,
                    width: 350,
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered ,
                      imageProvider: NetworkImage(
                        widget.images[selectedImageIndex],
                        // Ensures it fills the rounded shape properly
                      ),
                    ),),
                  Positioned(
                    top:10,
                      right: 10,
                      child: TCircularIcon(
                        onTap:()async{
                          await provider.toggleWishlist(widget.document!);
                          },
                        icon: wishlisted ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 78,
              child: ListView.separated(
                itemCount: widget.images.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(), // Allows smooth scrolling
                separatorBuilder: (_,__)=>SizedBox(width:6),
                itemBuilder: (_,index)=>GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImageIndex = index;
                    });
                    widget.onImageChange(index); // notify parent
                  },
                  child: TRoundedContainer(
                    margin: 2,
                    width:78,
                    radius: 0,
                    showBorder: true,
                    borderColor: selectedImageIndex == index ? Colors.blue : Colors.black26,
                    child:Image.network(
                      widget.images[index],
                      fit: BoxFit.cover, // Ensures it fills the rounded shape properly
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }
    );
  }
}
