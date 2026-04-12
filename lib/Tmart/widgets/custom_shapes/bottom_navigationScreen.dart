import 'package:flashchat/TMart/colors.dart';
import 'package:flashchat/TMart/screens/account_page.dart';
import 'package:flashchat/TMart/screens/auth/login_screen.dart';
import 'package:flashchat/TMart/screens/home.dart';
import 'package:flashchat/TMart/screens/store.dart';
import 'package:flashchat/TMart/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBarTheme(
        data: BottomNavigationBarThemeData(
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TColors.primary,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            setState(() {
              pageIdx = index;
            });
          },
          currentIndex: pageIdx,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home,color: Colors.green,),
                icon: Icon(Icons.home_outlined),
                label: 'Home'

            ),

            BottomNavigationBarItem(
              activeIcon: Icon(Icons.storefront_rounded,color: Colors.green,),
              icon: Badge(child: Icon(Icons.storefront_outlined)),
              label: 'Store',

            ),

            BottomNavigationBarItem(
              activeIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline_sharp, size: 25),
                label: 'Account'

            ),


            BottomNavigationBarItem(
              activeIcon:  Icon(Icons.favorite,color: Colors.green,),
              icon: Badge(child: Icon(Icons.favorite_border_outlined)),
              label: 'WishList',

            ),
          ],
        ),
      ),
      body:Center(
        child: Obx(() {  //taki lagout karne ke baad account page me change hoker
      final pages = [
        const Home(),
        const Store(),
        AuthController.instance.isLoggedIn ?  AccountPage() : LoginScreen(),
        const Wishlist(),
      ];
      return pages[pageIdx];
        }),
    ),

    );
  }
}