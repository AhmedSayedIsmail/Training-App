// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/models/trainer_requests_model.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/components/size_config.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class CustomRequestCard extends StatelessWidget {
  TraineesRequestsModel requestsItems;
  CustomRequestCard({required this.requestsItems});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: kPadding / 2,
            ),
            height: 200,
            child: Stack(
              children: [
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 15),
                          blurRadius: 25,
                          color: Colors.black12),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.deepOrangeAccent,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage("assets/images/account.png"),
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Name: ${requestsItems.traineename}".toUpperCase(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.5),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Email: ${requestsItems.traineeemail}",
                            style: TextStyle(
                                color: Colors.amber.shade900,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.5),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "PhoneNo: ${requestsItems.traineephone} \$",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 10,
                    bottom: 10,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              cubit.trainerRejectRequest(
                                accept: requestsItems.isAccepted,
                                emailTrainee: requestsItems.traineeemail,
                                nameTrainee: requestsItems.traineename,
                                phoneTrainee: requestsItems.traineephone,
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle),
                                child: Text(
                                  "Reject",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      color: Colors.blue),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              cubit.trainerAcceptRequest(
                                accept: requestsItems.isAccepted,
                                emailTrainee: requestsItems.traineeemail,
                                nameTrainee: requestsItems.traineename,
                                phoneTrainee: requestsItems.traineephone,
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle),
                                child: Text(
                                  "Accept",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      color: Colors.blue),
                                )),
                          ),
                        ])),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
