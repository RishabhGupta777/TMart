import 'package:flashchat/TMart/controller/all_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({
    super.key,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0; // Tracks the currently displayed image


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> banners= context.watch<AllProductProvider>().getAllBanners();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.0,
            autoPlay: true,
            enlargeCenterPage: true, // Enables the zoom effect
            enlargeFactor: 0.1, // Controls how much bigger the center image appears
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index; // Updates indicator when page changes
              });
            },
          ),
          items: banners.map((banner)  {
            final imageUrl=banner['pic'];
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical:12,horizontal:8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:Image.network(imageUrl,fit: BoxFit.cover),),
                  ),
                );
              },    //width: MediaQuery.of(context).size.width,
            );
          }).toList(),
        ),


        // **Dot Indicator Below the Carousel**
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex, // Binds to current image index
          count: banners.length, // Number of dots
          effect: const ExpandingDotsEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: Colors.blue, // Active dot color
            dotColor: Colors.grey, // Inactive dot color
          ),
        ),
      ],
    );
  }
}

