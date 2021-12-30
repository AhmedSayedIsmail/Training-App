import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/screens/trainers_screens/widgets/custom_request_card.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class TrainerRequestsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<TrainingCubit>(context)..showReqofTrainer(),
      child: BlocConsumer<TrainingCubit, TrainingStates>(
          builder: (context, state) {
            var cubit = TrainingCubit.getCubit(context);
            if (state is RequestPageInLoadingState ||
                cubit.showTraineesRequests.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => cubit.showReqofTrainer(),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Your Requests",
                          style: TextStyle(
                              // backgroundColor: Color(0xFF005e7f),
                              color: Color(0xFF005e7f),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        thickness: 2,
                        endIndent: 10,
                      ),
                      Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cubit.showTraineesRequests.length,
                            itemBuilder: (context, items) {
                              return CustomRequestCard(
                                requestsItems:
                                    cubit.showTraineesRequests[items],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          listener: (context, state) {}),
    );
  }
}
