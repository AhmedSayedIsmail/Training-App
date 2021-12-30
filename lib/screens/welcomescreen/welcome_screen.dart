import 'package:flutter/material.dart';
import 'package:training_app/screens/welcomescreen/widgets/welcome_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WelcomeBody(),
    );
  }
}
