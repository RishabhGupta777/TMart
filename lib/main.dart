import 'package:flashchat/Auth/controller/checkuser.dart';
import 'package:flashchat/Auth/view/screens/login_screen.dart';
import 'package:flashchat/Auth/view/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat/TMart/controller/addScreenProvider.dart';
import 'package:flashchat/TMart/controller/all_product_provider.dart';
import 'package:flashchat/TMart/controller/auth_controller.dart';
import 'package:flashchat/TMart/controller/internet_provider.dart';
import 'package:flashchat/TMart/controller/order_list_provider.dart';
import 'package:flashchat/TMart/controller/theme_provider.dart';
import 'package:flashchat/TMart/controller/wishlist_provider.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/bottom_navigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Tmart/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value){   // Initialize Firebase
    Get.put(AuthController());
  });// Initialize Firebase
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AddScreenProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => WishlistProvider()),
      ChangeNotifierProvider(create: (context) => AllProductProvider()),
      ChangeNotifierProvider(create: (context) => OrderListProvider()),
      ChangeNotifierProvider(create: (context) => InternetProvider()),
    ],
    child: const MyApp(), // Use 'const' with the constructor to improve performance.
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'TMart',
        themeMode: context.watch<ThemeProvider>().getThemeValue() ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          // scaffoldBackgroundColor: Colors.white,
          // appBarTheme: const AppBarTheme(
          // backgroundColor: Colors.white,
          useMaterial3: true,
        ),

        ///for E-comm
        home:BottomNavigationScreen(),
        /// for flashchat
        // initialRoute: CheckUser.id,
        routes: {     //map due to {}
          CheckUser.id: (context)=> const CheckUser(),
          WelcomeScreen.id: (context)=>const WelcomeScreen(),
          LoginScreen.id: (context)=>const LoginScreen(),
          RegistrationScreen.id:(context) =>const RegistrationScreen(),
        }


    );
  }
}

