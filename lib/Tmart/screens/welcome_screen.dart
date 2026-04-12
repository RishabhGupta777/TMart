import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/Auth/view/screens/login_screen.dart';
import 'package:flashchat/Auth/view/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_shapes/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;
  late Animation colourTween;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      upperBound: 1,
    ); //ticker

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    colourTween = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.forward(); // first forward jana chahiye
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    }); //animation value

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colourTween.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: controller.value * 70,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts:[TypewriterAnimatedText('Chat-flashchat',textStyle: const TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),)],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log In',colour:Colors.lightBlueAccent,onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.id);
              //Go to registration screen.
            } ,),
            RoundedButton(title:'Register',colour:Colors.blueAccent,onPressed: () {
              Navigator.pushReplacementNamed(context, RegistrationScreen.id);
              //Go to registration screen.
            } ,),
          ],
        ),
      ),
    );
  }
}

