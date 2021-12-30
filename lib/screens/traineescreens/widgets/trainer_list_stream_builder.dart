import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:training_app/screens/traineescreens/widgets/custom_widget.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';

class TrainerListStreamBuilder extends StatelessWidget {
  const TrainerListStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection(kTrainerCollection).snapshots(),
      builder: (context, snapshot) {
        List<CustomWidget> trainerWidgets = [];
        if (!snapshot.hasData) {
          //add here a spinner
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        final trainersData = snapshot.data!.docs;
        for (var trainerData in trainersData) {
          final trainerimage = trainerData.get("image");
          final trainername = trainerData.get("name");
          final traineremail = trainerData.get("email");
          final price = trainerData.get("price");
          final location = trainerData.get("location");
          //we will Trainer Data in the widget
          final trainerWidget = CustomWidget(
            trainerimage: trainerimage,
            trainername: trainername,
            traineremail: traineremail,
            price: price,
            location: location,
          );
          trainerWidgets.add(trainerWidget);
        }
        return Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: trainerWidgets,
          ),
        );
      },
    );
  }
}
