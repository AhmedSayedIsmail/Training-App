// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/shared/components/size_config.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          if (cubit.isTrainer) {
            // this for Trainer
            return Scaffold(
              body: cubit.trainer_screens[cubit.trainer_index],
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      label: "Requests",
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          "assets/images/requirements (1).png",
                        ),
                      )),
                  BottomNavigationBarItem(
                      label: 'Profile',
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            // AssetImage("assets/images/account.png")
                            NetworkImage(cubit.trainerImage),
                      )),
                  BottomNavigationBarItem(
                      label: 'Logout',
                      icon: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage("assets/images/logout.png"))),
                ],
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black87,
                onTap: (index) {
                  if (index < 2) {
                    print(index);
                    cubit.changeTrainerPagesIndex(index);
                  } else {
                    cubit.signOut(context);
                    cubit.trainer_index = 0;
                  }
                },
                elevation: 0.0,
                backgroundColor: Colors.white,
                currentIndex: cubit.trainer_index,
                selectedFontSize: 15,
              ),
            );
          } else {
            //this for Trainee
            return Scaffold(
              body: cubit.trainee_screens[cubit.trainee_index],
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      label: "Trainers",
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          "assets/images/trainer1.png",
                        ),
                      )),
                  BottomNavigationBarItem(
                      label: 'Profile',
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage("assets/images/account.png"),
                      )),
                  BottomNavigationBarItem(
                      label: 'Logout',
                      icon: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage("assets/images/logout.png"))),
                ],
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black87,
                onTap: (index) {
                  if (index < 2) {
                    print(index);
                    cubit.changeTraineePagesIndex(index);
                  } else {
                    cubit.signOut(context);
                    cubit.trainee_index = 0;
                  }
                },
                elevation: 0.0,
                backgroundColor: Colors.white,
                currentIndex: cubit.trainee_index,
                selectedFontSize: 15,
              ),
            );
          }
        },
        listener: (context, state) {});
  }
}
