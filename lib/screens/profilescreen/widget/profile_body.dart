// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/shared/components/custom_clipper.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          if (cubit.isTrainer) {
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 500.0,
                    child: Stack(
                      children: [
                        Container(),
                        ClipPath(
                          clipper: MyCustomerClipper(),
                          child: Container(
                            height: 300.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://lumiere-a.akamaihd.net/v1/images/sa_pixar_virtualbg_coco_16x9_9ccd7110.jpeg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 60.0,
                                backgroundImage:
                                    NetworkImage(cubit.trainerImage),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(cubit.personEmail,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(cubit.personName,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
          } else {
            //this Trainee Profile
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 500.0,
                    child: Stack(
                      children: [
                        Container(),
                        ClipPath(
                          clipper: MyCustomerClipper(),
                          child: Container(
                            height: 300.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://lumiere-a.akamaihd.net/v1/images/sa_pixar_virtualbg_coco_16x9_9ccd7110.jpeg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircleAvatar(
                                radius: 60.0,
                                backgroundImage:
                                    AssetImage("assets/images/account.png"),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(cubit.personEmail,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(cubit.personName,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(cubit.traineePhone,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
          }
        },
        listener: (context, state) {});
  }
}
