// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/components/size_config.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

//this Widget For the Design To Show TrainersData
class CustomWidget extends StatelessWidget {
  final String trainerimage;
  final String trainername;
  final String traineremail;
  final String price;
  final String location;
  const CustomWidget({
    required this.trainerimage,
    required this.trainername,
    required this.traineremail,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          return Container(
            margin: EdgeInsets.symmetric(
              // horizontal: kPadding,
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
                            image: NetworkImage(trainerimage),
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
                            "Name: $trainername".toUpperCase(),
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
                            "Email: $traineremail",
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
                            "Price-Per_Hour: $price \$",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: Colors.red),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Location: $location",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: Colors.green),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 10,
                    bottom: 10,
                    child: InkWell(
                      onTap: () {
                        cubit.traineeMakeRequest(email: traineremail);
                      },
                      child: state is RequestLoadingState
                          ? CircularProgressIndicator()
                          : Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle),
                              child: Text(
                                "Make Request",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              )),
                    ))
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
