import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class ImagePic extends StatelessWidget {
  const ImagePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          return Center(
            child: SizedBox(
                height: 115,
                width: 115,
                child: GestureDetector(
                  onTap: () {
                    cubit.selectPhoto(context);
                  },
                  child: Stack(children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: cubit.img == null
                              ? const AssetImage(
                                  "assets/images/Profile Image.png")
                              : FileImage(cubit.img!) as ImageProvider,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green.shade400),
                        child: const Icon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                )),
          );
        },
        listener: (context, state) {});
  }
}
