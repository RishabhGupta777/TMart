import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/user.dart';
import '../widgets/custom_shapes/bottom_navigationScreen.dart';


class AuthController extends GetxController {
  static AuthController instance = Get.find();


//User State Persistence



  final Rx<User?> _user = Rx<User?>(FirebaseAuth.instance.currentUser);
  User get user => _user.value!;

// _user  - Nadi
  // _user.bindStream - Nadi Me Color Deko
  //ever - Aap Ho
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialView);

    //Rx - Observable Keyword - Continously Checking Variable Is Changing Or Not.
  }

  _setInitialView(User? user){
    if(user == null){
      Get.offAll(()=> BottomNavigationScreen());
    }else{
      Get.offAll(() =>BottomNavigationScreen());
    }
  }

///User login or not in the variable
  bool get isLoggedIn => _user.value != null;

  //User Register

  void SignUp(
      String username, String email, String password) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty
        ) {
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        myUser user = myUser(name: username, email: email, uid: credential.user!.uid);

        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(user.toJson());

      }
    } catch (e) {
      print(e);
      Get.snackbar("Error Occurred", e.toString());
    }
  }



  void login(String email, String password) async
  {

    try{
  if(email.isNotEmpty && password.isNotEmpty){
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    print('login ho gya');
  }else{
    Get.snackbar("Error Logging In", "Please enter all the fields");
    print('put all values');
  }


    }catch(e){
Get.snackbar("Error Logging In",e.toString());
print('something went wrong');

    }
  }

  //for log Out
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

}
