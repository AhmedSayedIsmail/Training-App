// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_app/screens/traineescreens/widgets/trainersListBody.dart';
import 'package:training_app/shared/components/constants.dart';

class TrainersList extends StatelessWidget {
  const TrainersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      backgroundColor: trainersListBackgroundColor,
      body: TrainersListBody(),
    );
  }
}
