// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:training_app/screens/loginscreen/login_screen.dart';
import 'package:training_app/shared/components/components_widget.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/components/design_round_button.dart';
import 'package:training_app/shared/components/design_text_field.dart';
import 'package:training_app/shared/components/img_pic.dart';
import 'package:training_app/shared/components/size_config.dart';
import 'package:training_app/shared/cubit/training_cubit.dart';
import 'package:training_app/shared/cubit/training_states.dart';

class SignUpBody extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailCotroller = TextEditingController();
  var passwordController = TextEditingController();
  var locationController = TextEditingController();
  var priceController = TextEditingController();
  var phoneNumberController = TextEditingController();
  String countryCode = "";
  String phoneNoCountryCode = "";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<TrainingCubit, TrainingStates>(
        builder: (context, state) {
          var cubit = TrainingCubit.getCubit(context);
          if (cubit.isTrainer) {
            //this for Trainer
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  ImagePic(),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //this TextFormField For Name
                            SizedBox(height: SizeConfig.screenHeight! * 0.03),
                            DesignTextField(
                              controller: nameController,
                              hint_text: "Enter name...",
                              type: TextInputType.name,
                              validation: (namevalue) {
                                if (namevalue!.isEmpty) {
                                  return kNameNullError;
                                } else if (namevalue.length < 4) {
                                  return kNameisVeryShort;
                                } else {
                                  return null;
                                }
                              },
                              obscure_text: false,
                              perfixIcon: Icons.person,
                            ),
                            //this TextFormField For Email
                            SizedBox(height: SizeConfig.screenHeight! * 0.03),
                            DesignTextField(
                              controller: emailCotroller,
                              hint_text: "Enter email...",
                              type: TextInputType.emailAddress,
                              validation: (emailvalue) {
                                if (emailvalue!.isEmpty) {
                                  return kEmailNullError;
                                } else if (!regExp.hasMatch(emailvalue)) {
                                  return kInvalidEmailError;
                                } else {
                                  return null;
                                }
                              },
                              obscure_text: false,
                              perfixIcon: Icons.email,
                            ),
                            //this TextFormField For Password
                            SizedBox(height: SizeConfig.screenHeight! * 0.03),
                            DesignTextField(
                              controller: passwordController,
                              hint_text: "Enter password...",
                              validation: (passvalue) {
                                if (passvalue!.isEmpty) {
                                  return kPassNullError;
                                } else if (passvalue.length < 6) {
                                  return kShortPassError;
                                } else {
                                  return null;
                                }
                              },
                              obscure_text: cubit.issignupPasswordTrainer,
                              suffixIcon: cubit.issignupPasswordTrainer
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              suffixOnClick: () =>
                                  cubit.changesignupPasswordTrainer(),
                              perfixIcon: Icons.lock,
                            ),
                            //this TextFormField For Location
                            SizedBox(height: SizeConfig.screenHeight! * 0.03),
                            DesignTextField(
                              controller: locationController,
                              hint_text: "Enter location...",
                              type: TextInputType.streetAddress,
                              validation: (locationvalue) {
                                if (locationvalue!.isEmpty) {
                                  return kLocationNullError;
                                } else {
                                  return null;
                                }
                              },
                              obscure_text: false,
                              perfixIcon: Icons.location_city_outlined,
                            ),
                            //this TextFormField For Price per Hour
                            SizedBox(height: SizeConfig.screenHeight! * 0.03),
                            DesignTextField(
                              controller: priceController,
                              hint_text: "Enter price per hour...",
                              type: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              validation: (pricevalue) {
                                if (pricevalue!.isEmpty) {
                                  return kPriceNullError;
                                } else {
                                  return null;
                                }
                              },
                              obscure_text: false,
                              perfixIcon: FontAwesomeIcons.dollarSign,
                            ),
                          ],
                        ),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                      state is SignupLoadingState
                          ? CircularProgressIndicator()
                          : DesignRoundButton(
                              text: "Sign up".toUpperCase(),
                              onPress: () {
                                if (_formKey.currentState!.validate() &&
                                    cubit.img != null) {
                                  cubit.signupcreateEmail(
                                    name: nameController.text,
                                    email: emailCotroller.text,
                                    password: passwordController.text,
                                    location: locationController.text,
                                    price: priceController.text,
                                    phoneNo: "",
                                    context: context,
                                  );
                                } else if (cubit.img == null) {
                                  Fluttertoast.showToast(
                                    msg: "You must choose Image",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                }
                              },
                            ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Alrady Have An Account?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateAndFinish(context, const LoginScreen());
                            },
                            child: Text(
                              "\tLogin".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    ],
                  )
                ],
              ),
            ));
          } else {
            //this for Trainee
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Image.asset(
                    "assets/images/logo_drive.png",
                    width: 150,
                    height: 150,
                  )),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                  Text(
                    "Signup",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(kPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //this TextFormField For Name
                          SizedBox(height: SizeConfig.screenHeight! * 0.02),
                          DesignTextField(
                            controller: nameController,
                            hint_text: "Enter name...",
                            type: TextInputType.name,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return kNameNullError;
                              } else if (value.length < 4) {
                                return kNameisVeryShort;
                              } else {
                                return null;
                              }
                            },
                            obscure_text: false,
                            perfixIcon: Icons.person,
                          ),
                          //this TextFormField For Email
                          SizedBox(height: SizeConfig.screenHeight! * 0.03),
                          DesignTextField(
                            controller: emailCotroller,
                            hint_text: "Enter email...",
                            type: TextInputType.emailAddress,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return kEmailNullError;
                              } else if (!regExp.hasMatch(value)) {
                                return kInvalidEmailError;
                              } else {
                                return null;
                              }
                            },
                            obscure_text: false,
                            perfixIcon: Icons.email,
                          ),
                          //this TextFormField For Password
                          SizedBox(height: SizeConfig.screenHeight! * 0.03),
                          DesignTextField(
                              controller: passwordController,
                              hint_text: "Enter password...",
                              type: TextInputType.visiblePassword,
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return kPassNullError;
                                } else if (value.length < 6) {
                                  return kShortPassError;
                                } else {
                                  return null;
                                }
                              },
                              obscure_text: cubit.issignupPasswordTrainee,
                              suffixIcon: cubit.issignupPasswordTrainee
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              suffixOnClick: () {
                                cubit.changesignupPasswordTrainee();
                              },
                              perfixIcon: Icons.lock),
                          //   this IntlPhoneField to write phone number and get countrycode
                          SizedBox(height: SizeConfig.screenHeight! * 0.03),
                          IntlPhoneField(
                            countryCodeTextColor: Colors.white,
                            showDropdownIcon: false,
                            dropDownIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              hintText: "Enter phone number...",
                              filled: true,
                              counterStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(Icons.phone),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 3)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 5)),
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              fillColor: Color(0xFFF2F2F2),
                              border: OutlineInputBorder(),
                            ),
                            autoValidate: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return kPhoneNumberNullError;
                              } else if (value.length != 10) {
                                return kPhoneLengthError;
                              } else {
                                return null;
                              }
                            },
                            inputFormatters: [
                              //To remove first '0'
                              FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                            ],
                            onCountryChanged: (phone) {
                              print('Country code changed to: ' +
                                  phone.countryCode.toString());
                              countryCode = phone.countryCode.toString();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                      state is SignupLoadingState
                          ? CircularProgressIndicator()
                          : DesignRoundButton(
                              text: "Sign up".toUpperCase(),
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  phoneNoCountryCode =
                                      countryCode + phoneNumberController.text;
                                  cubit.signupcreateEmail(
                                      name: nameController.text,
                                      email: emailCotroller.text,
                                      password: passwordController.text,
                                      context: context,
                                      location: "",
                                      price: "",
                                      phoneNo: phoneNoCountryCode);
                                }
                              },
                            ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Alrady Have An Account?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateAndFinish(context, LoginScreen());
                            },
                            child: Text(
                              "\tLogin".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    ],
                  ),
                ],
              ),
            ));
          }
        },
        listener: (context, state) {});
  }
}
