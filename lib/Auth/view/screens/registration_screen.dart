
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../Tmart/constants.dart';
import '../../../Tmart/widgets/custom_shapes/rounded_button.dart';

User? loggedInUser;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';


  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner=false;
  late String email;
  late String password;
  final  _auth=FirebaseAuth.instance;   //_auth is object and FirebaseAuth isa class
  bool showPassword = false;

  getRegister(){
    _firestore.collection('UserId').add({
      'register': loggedInUser?.email,   //loggedInUser is a User? Object, Not a String
      //When adding data to Firestore, the sender field should store a string (like the user's email), not a User? object
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
          inAsyncCall:showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email',suffixIcon:const Icon(Icons.email),),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: showPassword==false ? true : false ,
                textAlign: TextAlign.center,
                onChanged: (value) {
                 password=value;
                },
                decoration:InputDecoration(
                  suffixIcon:IconButton(
                      onPressed:(){
                        setState(() {
                          showPassword ? showPassword=false : showPassword= true;
                        });
                         },
                    icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off), // Change icon
                  ),
                  hintText: 'Enter your password',
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title:'Register',
                  colour: Colors.blueAccent,
                  onPressed:() async{
                    setState(() {
                      showSpinner=true;
                    });
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                   //taki emailId ka alag document ban sake
                   loggedInUser = newUser.user; // Assign the new user to loggedInUser
                   getRegister(); // Now call getRegister() after assigning loggedInUser

                     //Navigator.pushReplacementNamed(context, HomePage.id);
                                       setState(() {
                        showSpinner=false;
                      });
                    } catch(e){
                      print(e);
                      showDialog(
                          context: context,
                          builder: (context)=>AlertDialog(
                            title:const Text('Something Went Wrong',style: TextStyle(fontSize: 22),),
                            actions: [
                              TextButton(
                                  onPressed:(){
                                    Navigator.pop(context);

                                    // speaner ka ghumna bhi band kar do
                                    setState(() {
                                      showSpinner=false;
                                    });
                                  },
                                  child: const Text('Try again'))
                            ],
                          ));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
