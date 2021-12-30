// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/screens/signupscreen/sign_up_screen.dart';
import 'package:training_app/shared/components/components_widget.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/components/design_round_button.dart';
import 'package:training_app/shared/components/design_text_field.dart';
import 'package:training_app/shared/components/size_config.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class LoginBody extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          return SafeArea(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Image.asset(
                  "assets/images/logo_drive.png",
                  width: 150,
                  height: 150,
                )),
                SizedBox(height: SizeConfig.screenHeight! * 0.02),
                Text(
                  cubit.isTrainer ? "Trainer Login" : "Trainee Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                Form(
                    key: _formkey,
                    child: Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //this TextFormField For Email
                          SizedBox(height: SizeConfig.screenHeight! * 0.05),
                          DesignTextField(
                            controller: emailController,
                            hint_text: "Enter Email",
                            type: TextInputType.emailAddress,
                            validation: (emailvalue) {
                              if (emailvalue!.isEmpty) {
                                return kEmailNullError;
                              } else if (!regExp.hasMatch(emailvalue)) {
                                return kInvalidEmailError;
                              } else {
                                return null;
                              }
                            },
                            obscure_text: false,
                            perfixIcon: Icons.email,
                          ),
                          //this TextFormField For Password
                          SizedBox(height: SizeConfig.screenHeight! * 0.08),
                          DesignTextField(
                            controller: passwordController,
                            hint_text: "Enter Password",
                            type: TextInputType.visiblePassword,
                            validation: (passwordvalue) {
                              if (passwordvalue!.isEmpty) {
                                return kPassNullError;
                              } else if (passwordvalue.length < 6) {
                                return kShortPassError;
                              } else {
                                return null;
                              }
                            },
                            obscure_text: cubit.isloginPassword,
                            suffixIcon: cubit.isloginPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            suffixOnClick: () {
                              cubit.changeLoginPasswordShow();
                            },
                            perfixIcon: Icons.lock,
                          ),
                        ],
                      ),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight! * 0.08),
                    state is LoginLoadingState
                        ? CircularProgressIndicator()
                        : DesignRoundButton(
                            text: "Login".toUpperCase(),
                            onPress: () {
                              if (_formkey.currentState!.validate()) {
                                cubit.loginWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context,
                                );
                              }
                            },
                          ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.08),
                    InkWell(
                      onTap: () {
                        navigateTo(context, SignUpScreen());
                      },
                      child: Text(
                        "SIGNUP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
        },
        listener: (context, state) {});
  }
}
