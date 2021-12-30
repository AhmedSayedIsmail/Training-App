import 'package:flutter/material.dart';
import 'package:training_app/screens/loginscreen/widget/login_body.dart';
import 'package:training_app/screens/welcomescreen/welcome_screen.dart';
import 'package:training_app/shared/components/components_widget.dart';
import 'package:training_app/shared/components/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: loginBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(kloginTitle),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              navigateAndFinish(context, const WelcomeScreen());
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ),
        body: LoginBody());
  }
}
