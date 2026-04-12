import 'package:flashchat/TMart/controller/auth_controller.dart';
import 'package:flashchat/TMart/controller/internet_provider.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/button.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/glitch_effect.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../widgets/base_scaffold.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _setPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      body: Center(
        child: SingleChildScrollView(
          child: TRoundedContainer(
            margin: 10,
            padding: 10,
            radius: 12,
            backgroundColor: const Color(0xFFE9F2F9),
            showBorder: true,
            borderColor: Colors.black12,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Title
                const SizedBox(height: 10),
                GlitchEffect(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Create ",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please fill in the details below to create your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 25),
          
                /// Username
                TextInputField(
                  controller: _usernameController,
                  myLabelText: "Username",
                  myIcon: Icons.person,
                ),
          
                const SizedBox(height: 20),
          
                /// Email
                TextInputField(
                  controller: _emailController,
                  myLabelText: "Email",
                  myIcon: Icons.email,
                ),
          
                const SizedBox(height: 20),
          
                /// Set Password
                TextInputField(
                  controller: _setPasswordController,
                  myLabelText: "Set Password",
                  myIcon: Icons.lock,
                  toHide: true,
                ),
          
                const SizedBox(height: 20),
          
                /// Confirm Password
                TextInputField(
                  controller: _confirmPasswordController,
                  myLabelText: "Confirm Password",
                  myIcon: Icons.lock,
                  toHide: true,
                ),
          
                const SizedBox(height: 25),
          
                /// Signup Button
                TButton(
                  width: double.infinity,
                  height: 48,
                  text: "SIGN UP",
                  onTap: () {
                    if (_setPasswordController.text ==
                        _confirmPasswordController.text) {
                      AuthController.instance.SignUp(
                        _usernameController.text,
                        _emailController.text,
                        _setPasswordController.text,
                      );
                    } else {
                      Get.snackbar("Error", "Passwords do not match",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent.withOpacity(0.2),
                          colorText: Colors.black);
                    }
                  },
                  backgroundColor: Colors.blueGrey.shade200,
                  textColor: Colors.black,
                  radius: 8,
                ),
          
                const SizedBox(height: 15),
                const Text(
                  "By Signing Up, you agree to Terms & Conditions and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF7A7A7A),
                      fontSize: 11,
                      fontWeight: FontWeight.w800),
                ),
          
                const SizedBox(height: 20),
          
                /// Already have account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Get.to(() => LoginScreen()),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
