import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/TMart/screens/user_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';
import '../controller/internet_provider.dart';
import '../controller/theme_provider.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_shapes/no_internet_box.dart';
import 'cart_screen.dart';
import 'my_Profile.dart';
import 'orderlistsItems.dart';



class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().checkConnection();
    _fetchUserInfo();
  }

  final _auth = FirebaseAuth.instance; //_auth is object and FirebaseAuth isa class
  String name = "Loading... ";
  String? userProfileUrl;
  bool isLoading = true; // Track loading state


  void _fetchUserInfo() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('UsersInfo').doc(_auth.currentUser!.email).get();
    if (userDoc.exists) {
      final data=userDoc.data() as Map<String,dynamic> ? ;
      setState(() {
        name = data?['name'] ?? "No Name";
        userProfileUrl = data?['profilePic'];
        isLoading = false; // Stop loading once data is fetched
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    String ? loggedInUser = _auth.currentUser!.email; // Get current user
    return Consumer<InternetProvider>(
      builder: (context, provider, _) {
        if (provider.isOnline == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.isOnline == false) {
          return Scaffold(
            body: NoInternetBox(provider),
          );
        }

        return Scaffold(

          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),),
                accountEmail:Text('$loggedInUser' ,style: Theme.of(context).textTheme.bodyMedium,),
                currentAccountPicture: CircleAvatar(
                  radius: 77, // Adjust the size
                  backgroundColor: Colors.white,
                  child: userProfileUrl != null
                      ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userProfileUrl!,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  )
                      : const Icon(Icons.person, size: 40, color: Colors.white),
                ),

                decoration:BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor, // adapts to theme
                ),
              ),
              ListTile(
                onTap: (){ Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>const MyProfile(),),
                );},
                leading: const Icon(Icons.person_outline_sharp),
                title: const Text('My Profile'),
              ),
              ListTile(
                leading: const Icon(Icons.light_mode_outlined),
                subtitle: Consumer<ThemeProvider>(
                  builder: (ctx, provider, _) {
                    return SwitchListTile.adaptive(
                      activeColor: Colors.white,
                      title: const Text("Dark Mode"),
                      subtitle: const Text("Change theme"),
                      value: provider.getThemeValue(),
                      onChanged: (value) {
                        provider.updateTheme(value: value);
                      },
                    );
                  },
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserAddressScreen(),));
                },
                leading: Icon(Icons.home_work_outlined),
                title: Text('My Address'),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen(),));
                },
                leading: Icon(Icons.shopping_cart_outlined),
                title: Text('My Cart'),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TOrderListItems(),));
                },
                leading: Icon(Icons.local_shipping_outlined,),
                title: Text('My Orders'),
              ),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('LogOut'),
                  onTap: () {
                    AuthController.instance.logout();
                  }),

            ],
          ),
        );
      },
    );
  }
}
