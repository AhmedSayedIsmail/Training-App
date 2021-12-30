// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/screens/loginscreen/login_screen.dart';
import 'package:training_app/shared/components/components_widget.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/components/size_config.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider.value(
      value: BlocProvider.of<TrainingCubit>(context)
        ..getUidOfTrainers()
        ..getUidOfTrainees(),
      child: BlocConsumer<TrainingCubit, TrainingStates>(
          builder: (context, state) {
            var cubit = TrainingCubit.getCubit(context);
            return SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(80),
                    ),
                    const Text(
                      "Welcome!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.01),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to our application",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                          Text(
                            "where you can Login or Register As Trainer or Trainee",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.08),
                    Center(
                      child: Image.asset(
                        "assets/images/driving_train.png",
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.04),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    ButtonWidget(
                        text: kWelcomeTrainerTextButton,
                        onPress: () {
                          cubit.isTrainer = true;
                          navigateAndFinish(context, const LoginScreen());
                        }),
                    SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    ButtonWidget(
                        text: kWelcomeTraineeTextButton,
                        onPress: () {
                          cubit.isTrainer = false;
                          navigateAndFinish(context, const LoginScreen());
                        }),
                  ],
                )),
              ),
            );
          },
          listener: (context, state) {}),
    );
  }
}

Widget ButtonWidget({text, onPress}) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15),
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(welcomeButtomColor),
        ),
        child: Center(
          child: Text(
            text!,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ));
}
