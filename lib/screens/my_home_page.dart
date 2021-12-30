import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TrainingCubit, TrainingStates>(
          builder: (context, state) {
            var cubit = TrainingCubit.getCubit(context);
            return SafeArea(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          // cubit.plus();
                        },
                        child: Icon(Icons.add)),
                    Text(
                      '{cubit.num}',
                      style: TextStyle(fontSize: 25),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // cubit.minus();
                        },
                        child: Icon(Icons.remove))
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {}),
    );
  }
}
