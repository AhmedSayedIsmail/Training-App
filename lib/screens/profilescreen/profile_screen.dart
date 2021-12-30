// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:training_app/screens/profilescreen/widget/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileBody(),
    );
  }
}
