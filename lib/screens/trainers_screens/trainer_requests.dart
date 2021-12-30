import 'package:flutter/material.dart';
import 'package:training_app/screens/trainers_screens/widgets/trainer_requests_body.dart';

class TrainerRequests extends StatelessWidget {
  const TrainerRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TrainerRequestsBody(),
    );
  }
}
