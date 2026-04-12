import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Tmart/screens/welcome_screen.dart';


class CheckUser extends StatefulWidget {
  static const String id = 'checkuser';

  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return checkUser();
  }

  checkUser(){
    final user= _auth.currentUser;
    if(user!=null){
      return null;
    }else{
      return const WelcomeScreen();
    }
  }

}

