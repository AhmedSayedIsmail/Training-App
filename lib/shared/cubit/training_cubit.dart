import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:training_app/models/trainee_model.dart';
import 'package:training_app/models/trainer_model.dart';
import 'package:training_app/models/trainer_requests_model.dart';
import 'package:training_app/screens/homescreen/home_screen.dart';
import 'package:training_app/screens/profilescreen/profile_screen.dart';
import 'package:training_app/screens/traineescreens/trainers_list.dart';
import 'package:training_app/screens/trainers_screens/trainer_requests.dart';
import 'package:training_app/screens/welcomescreen/welcome_screen.dart';
import 'package:training_app/shared/components/components_widget.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/cubit/training_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';

class TrainingCubit extends Cubit<TrainingStates> {
  TrainingCubit() : super(InitialState());
  static TrainingCubit getCubit(context) => BlocProvider.of(context);
  bool isTrainer = false;
  bool issignupPasswordTrainer = true;
  bool issignupPasswordTrainee = true;
  bool isloginPassword = true;
  //this function to show password or disshow password in login screen
  void changeLoginPasswordShow() {
    isloginPassword = !isloginPassword;
    emit(ChangeLoginPasswordState());
  }

  //this function to show password or disshow password in register screen Trainer
  void changesignupPasswordTrainer() {
    issignupPasswordTrainer = !issignupPasswordTrainer;
    emit(ChangeSignupPasswordState());
  }

  //this function to show password or disshow password in register screen Trainee
  void changesignupPasswordTrainee() {
    issignupPasswordTrainee = !issignupPasswordTrainee;
    emit(ChangeSignupPasswordState());
  }

  File? img;
  final imagePicker = ImagePicker();
  //this functions to selectPhoto
  Future selectPhoto(context) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
            builder: (context) => Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Camera'),
                      onTap: () {
                        pickImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.filter),
                      title: const Text('Pick a ImageFile'),
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
            onClosing: () {}));
  }

  Future pickImage(ImageSource source) async {
    img = null;
    //this variable final image that get from user
    var image = await imagePicker.pickImage(source: source);
    if (image != null) {
      img = File(image.path);
      print("SelectedImageState");
      emit(SelectedImageState());
    } else {
      print("NoSelectedImageState");
      emit(NoSelectedImageState());
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;
  TrainerModel? trainerModel;
  TraineeModel? traineeModel;
  // this function for registeration in firebase
  void signupcreateEmail({
    name,
    email,
    password,
    location,
    price,
    phoneNo,
    context,
  }) async {
    emit(SignupLoadingState());
    await Future.delayed(const Duration(seconds: 5));
    if (isTrainer) {
      try {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //this for Trainer
        storage.FirebaseStorage.instance
            .ref()
            .child('persons images')
            .child(Uri.file(img!.path).pathSegments.last)
            .putFile(img!)
            .then((val) {
          val.ref.getDownloadURL().then((imgvalue) {
            trainerModel = TrainerModel(
              name: name,
              email: userCredential!.user!.email,
              location: location,
              pic: imgvalue,
              price: price,
              uid: userCredential!.user!.uid,
              isTrainer: isTrainer,
            );
            FirebaseFirestore.instance
                .collection(kTrainerCollection)
                .doc(userCredential!.user!.uid)
                .set(trainerModel!.toMap())
                .then((value) async {
              Fluttertoast.showToast(
                msg: "Save Data Succeeded",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
              print("Timer");
              await Future.delayed(const Duration(seconds: 5));
              getPersonData(context);
            }).catchError((e) async {
              //in this senario if the data of trainer not saved in database fire store
              //the email and password that auth will be deleted from firebase  after signout
              emit(TrainerDataSavedFailed());
              print("TrainerDataSavedFailed");
              Fluttertoast.showToast(
                msg: "Save Data Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
              await FirebaseAuth.instance.signOut();
              userCredential = null;
              try {
                await FirebaseAuth.instance.currentUser!.delete();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'requires-recent-login') {
                  print(
                      'The user must reauthenticate before this operation can be executed.');
                }
              }
            });
          }).catchError((e) {
            emit(AddImageInStorageErrorState());
            print("AddImageInStorageErrorState");
            Fluttertoast.showToast(
              msg: e.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
              msg: 'The password is too weak.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              textColor: Colors.white);
          emit(PasswordVeryWeek());
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: 'The account already exists for that email.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              textColor: Colors.white);
          emit(EmailExistState());
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //this for trainee
        traineeModel = TraineeModel(
            name: name,
            email: userCredential!.user!.email,
            phoneNo: phoneNo,
            uid: userCredential!.user!.uid,
            isTrainer: isTrainer);
        FirebaseFirestore.instance
            .collection(kTraineeCollection)
            .doc(userCredential!.user!.uid)
            .set(traineeModel!.toMap())
            .then((value) async {
          Fluttertoast.showToast(
            msg: "Save Data Succeeded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          await Future.delayed(const Duration(seconds: 5));
          getPersonData(context);
        }).catchError((e) async {
          //in this senario if the data of trainee not saved in database fire store
          //the email and password that auth will be deleted from firebase  after signout
          emit(TraineeDataSavedFailed());
          print("TraineeDataSavedFailed");
          Fluttertoast.showToast(
            msg: "Save Data Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          await FirebaseAuth.instance.signOut();
          userCredential = null;
          try {
            await FirebaseAuth.instance.currentUser!.delete();
          } on FirebaseAuthException catch (e) {
            if (e.code == 'requires-recent-login') {
              print(
                  'The user must reauthenticate before this operation can be executed.');
            }
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
              msg: 'The password is too weak.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              textColor: Colors.white);
          emit(PasswordVeryWeek());
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: 'The account already exists for that email.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              textColor: Colors.white);
          emit(EmailExistState());
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  List? traineruid;
  List? traineeuid;
  void getUidOfTrainers() async {
    traineruid = [];
    await FirebaseFirestore.instance
        .collection(kTrainerCollection)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        traineruid!.add(element.data()['uid']);
      });
    });
    print(traineruid);
  }

  void getUidOfTrainees() async {
    traineeuid = [];
    await FirebaseFirestore.instance
        .collection(kTraineeCollection)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        traineeuid!.add(element.data()['uid']);
      });
    });
    print(traineeuid);
  }

//this method to login in
  void loginWithEmailAndPassword({email, password, context}) async {
    emit(LoginLoadingState());
    await Future.delayed(const Duration(seconds: 5));
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        if (isTrainer && traineruid!.contains(value.user!.uid)) {
          emit(TrainerLoginState());
          Fluttertoast.showToast(
            msg: "LoginSucceesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          getPersonData(context);
        } else if (!isTrainer && traineeuid!.contains(value.user!.uid)) {
          emit(TraineeLoginState());
          Fluttertoast.showToast(
            msg: "LoginSucceesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          getPersonData(context);
        } else {
          if (isTrainer) {
            await FirebaseAuth.instance.signOut();
            emit(WriteEmailInWrongPlace());
            Fluttertoast.showToast(
                msg: kEmailNotFoundtrainer,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: kToastErrorColor);
          } else {
            await FirebaseAuth.instance.signOut();
            userCredential = null;
            emit(WriteEmailInWrongPlace());
            Fluttertoast.showToast(
                msg: kEmailNotFoundtrainee,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: kToastErrorColor);
            print(userCredential.toString());
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(EmailErrorState());
        Fluttertoast.showToast(
            msg: kEmailNotFound,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: kToastErrorColor);
      } else if (e.code == 'wrong-password') {
        emit(PasswordErrorState());
        Fluttertoast.showToast(
            msg: kPasswordNotProvidedforthatEmail,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: kToastErrorColor);
        print('Wrong password provided for that user.');
      }
    }
  }

  Map<String, dynamic>? persondata = {};
  var personName, personEmail, personType, personUid;
  var trainerImage, trainerLocation, trainerPrice;
  var traineePhone;
  Future getPersonData(context) async {
    persondata = {};
    if (isTrainer) {
      await FirebaseFirestore.instance
          .collection(kTrainerCollection)
          .doc(userCredential!.user!.uid)
          .get()
          .then((value) {
        print("**************the trainer data is getted**********");
        persondata = value.data();
        personName = persondata!['name'];
        personEmail = persondata!['email'];
        personType = persondata!['istrainer'];
        personUid = persondata!['uid'];
        trainerImage = persondata!['image'];
        trainerLocation = persondata!['location'];
        trainerPrice = persondata!['price'];
        print('"isTrainer:"+ ${personType.toString()}');
        print('"Image:"+ ${trainerImage.toString()}');
        Fluttertoast.showToast(
          msg: "TrainerData",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        emit(SignupSuccessfully());
        emit(GetTrainerDataSuccessfully());
        navigateAndFinish(context, const HomeScreen());
      }).catchError((e) {
        print("Some Problems Happend to get Trainer From Data CloudFireStore");
        Fluttertoast.showToast(
          msg: "Some Problems Happend",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      });
    } else {
      //Trainees
      await FirebaseFirestore.instance
          .collection(kTraineeCollection)
          .doc(userCredential!.user!.uid)
          .get()
          .then((value) {
        print("**************the trainee data is getted**********");
        persondata = value.data();
        personName = persondata!["name"];
        personEmail = persondata!["email"];
        personType = persondata!['istrainer'];
        personUid = persondata!['uid'];
        traineePhone = persondata!["phoneNo"];
        print('"isTrainer:"+ ${personType.toString()}');
        Fluttertoast.showToast(
          msg: "TraineeData",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        emit(SignupSuccessfully());
        emit(GetTraineeDataSuccessfully());
        navigateAndFinish(context, const HomeScreen());
      }).catchError((e) {
        print("Some Problems Happend to get Trainee From Data CloudFireStore");
        Fluttertoast.showToast(
          msg: "Some Problems Happend",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      });
    }
  }

  var trainee_index = 0;
  var trainee_screen_title = ["Trainers", "Profile"];
  var trainee_screens = [const TrainersList(), const ProfileScreen()];
  var trainer_index = 0;
  var trainer_screen_title = ["Requests", "Profile"];
  var trainer_screens = [const TrainerRequests(), const ProfileScreen()];
  void changeTraineePagesIndex(int index) {
    trainee_index = index;
    emit(BottomNavigationBarIndexChanged());
  }

  void changeTrainerPagesIndex(int index) {
    trainer_index = index;
    emit(BottomNavigationBarIndexChanged());
  }

  //get all Trainers that in Data base and show to Trainees
  List<TrainerModel> showTrainerDataList = [];
  void showTrainersData() async {
    showTrainerDataList = [];
    emit(ShowListofTrainersLoadingState());
    await Future.delayed(const Duration(seconds: 5));
    await FirebaseFirestore.instance
        .collection(kTrainerCollection)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        showTrainerDataList.add(TrainerModel.fromJson(element.data()));
      });
      if (showTrainerDataList.length == value.docs.length &&
          showTrainerDataList.isNotEmpty) {
        print(showTrainerDataList.length);
        emit(ShowTrainerDataSuccessfully());
        Fluttertoast.showToast(
          msg: "The Data is Back in Good Shape",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        emit(ShowTrainerDataIsEmptyState());
        Fluttertoast.showToast(
          msg: "Not Find Data To Display it",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }).catchError((e) {
      emit(ShowTrainerDataErrorState());
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //this method to show requests to trainer
  List<TraineesRequestsModel> showTraineesRequests = [];
  Future showReqofTrainer() async {
    showTraineesRequests = [];
    emit(RequestPageInLoadingState());
    await Future.delayed(const Duration(seconds: 5));
    await FirebaseFirestore.instance
        .collection(kRequestsCollection)
        .doc(personEmail)
        .get()
        .then((value) {
      value.data()!.entries.forEach((element) {
        var map = HashMap.from(element.value);
        showTraineesRequests.add(
            TraineesRequestsModel.fromJson(Map<String, dynamic>.from(map)));
      });
      if (showTraineesRequests.length == value.data()!.length &&
          showTraineesRequests.isNotEmpty) {
        print(showTraineesRequests.length);
        emit(RequestedShowenToTrainer());
        Fluttertoast.showToast(
          msg: "The Data Of Requsts is Come Back in Good Shape",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        emit(RequestedShowenToTrainerErrorState());
        Fluttertoast.showToast(
          msg: "Not Find Data Of Requests To Display it",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  //this method called in custom_widget to make trainee make request
  TraineesRequestsModel? traineesRequestsModel;
  Future traineeMakeRequest({required email}) async {
    emit(RequestLoadingState());
    await Future.delayed(const Duration(seconds: 5));
    traineesRequestsModel = TraineesRequestsModel(
      traineename: personName,
      traineeemail: personEmail,
      traineephone: traineePhone,
      isAccepted: false,
    );
    await FirebaseFirestore.instance
        .collection(kRequestsCollection)
        .doc(email)
        .get()
        .then((value) async {
      print(value.data()!.keys.length);
      await FirebaseFirestore.instance
          .collection(kRequestsCollection)
          .doc(email)
          .set({personEmail: traineesRequestsModel!.toMap()},
              SetOptions(merge: true)).then((value) {
        emit(RequestSended());
        Fluttertoast.showToast(
          msg: "Request is Sended",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }).catchError((e) {
        emit(RequestError());
        Fluttertoast.showToast(
          msg: "Request is not Sended",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      });
    }).catchError((e) async {
      await FirebaseFirestore.instance
          .collection(kRequestsCollection)
          .doc(email)
          .set({personEmail: traineesRequestsModel!.toMap()},
              SetOptions(merge: true)).then((value) {
        emit(RequestSended());
        Fluttertoast.showToast(
          msg: "Request is Sended",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }).catchError((e) {
        emit(RequestError());
        Fluttertoast.showToast(
          msg: "Request is not Sended",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      });
    });
  }

  //this function for the trainer to accept the request of trainee
  TraineesRequestsModel? updateSpecialtraineeRequestModel;
  Future trainerAcceptRequest(
      {required accept,
      required emailTrainee,
      required nameTrainee,
      required phoneTrainee}) async {
    print(accept.toString());
    print(emailTrainee.toString());
    print(personEmail);
    emit(TrainerAcceptRequestLoadingState());
    await Future.delayed(const Duration(seconds: 5));
    if (accept) {
      emit(TrainerAcceptRequestSuccessfuly());
      Fluttertoast.showToast(
        msg: "You Accept The Request",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      accept = !accept;
      print(accept);
      updateSpecialtraineeRequestModel = TraineesRequestsModel(
        traineename: nameTrainee,
        traineeemail: emailTrainee,
        traineephone: phoneTrainee,
        isAccepted: accept,
      );
      await FirebaseFirestore.instance
          .collection(kRequestsCollection)
          .doc(personEmail)
          .set({emailTrainee: updateSpecialtraineeRequestModel!.toMap()},
              SetOptions(merge: true)).then((value) {
        emit(TrainerAcceptRequestSuccessfuly());
        Fluttertoast.showToast(
          msg: "You Accept The Request Of Trainee",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      });
      showReqofTrainer();
    }
  }

  //this function for the trainer to reject the request of trainee
  Future trainerRejectRequest(
      {required accept,
      required emailTrainee,
      required nameTrainee,
      required phoneTrainee}) async {
    emit(TrainerRejectRequestLoadingState());
    await Future.delayed(const Duration(seconds: 5));
    if (accept) {
      accept = !accept;
      print(accept);
      updateSpecialtraineeRequestModel = TraineesRequestsModel(
        traineename: nameTrainee,
        traineeemail: emailTrainee,
        traineephone: phoneTrainee,
        isAccepted: accept,
      );
      await FirebaseFirestore.instance
          .collection(kRequestsCollection)
          .doc(personEmail)
          .set({emailTrainee: updateSpecialtraineeRequestModel!.toMap()},
              SetOptions(merge: true)).then((value) {
        emit(TrainerRejectRequestSuccessfuly());
        Fluttertoast.showToast(
          msg: "You Reject The Request Of Trainee",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      });
      showReqofTrainer();
    } else {
      emit(TrainerRejectRequestSuccessfuly());
      Fluttertoast.showToast(
        msg: "You Reject The Request",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  //this method to sign out
  Future signOut(context) async {
    await FirebaseAuth.instance.signOut();
    userCredential = null;
    emit(UserSignOutSuccessfully());
    navigateAndFinish(context, const WelcomeScreen());
  }
}
