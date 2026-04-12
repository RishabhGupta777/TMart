import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../Tmart/constants.dart';
import '../../../Tmart/widgets/custom_shapes/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner=false;
  final  _auth=FirebaseAuth.instance;   //_auth is object and FirebaseAuth isa class
  late String email;
  late String password;

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
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email',suffixIcon:const Icon(Icons.email),),
              ),
              const SizedBox(
                height: 8.0,
              ),

              PasswordTextField(onChanged:(value) {
                 password=value;
          },),


              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title:'Log In',
                  colour: Colors.lightBlueAccent,
                  onPressed:()async{
                    setState(() {
                      showSpinner=true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      setState(() {
                        showSpinner=false;
                      });
                    } catch (e){
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
