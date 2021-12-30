import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/screens/traineescreens/widgets/trainer_list_stream_builder.dart';
import 'package:training_app/shared/components/size_config.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class TrainersListBody extends StatelessWidget {
  const TrainersListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          return SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Center(
                    child: Text(
                      cubit.trainee_screen_title[cubit.trainee_index] +
                          "\t List",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  )
                ],
              ),
              const TrainerListStreamBuilder(),
            ],
          ));
        },
        listener: (context, state) {});
  }
}
