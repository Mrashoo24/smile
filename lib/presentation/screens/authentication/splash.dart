import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile/data/models/userModel.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';
import 'package:smile/presentation/screens/authentication/loginscreen.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingh_history_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AuthController authController = Get.find<AuthController>();
  @override
  void initState() {
   navigate();
    super.initState();
  }

  navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var value = prefs.getString('user');
    await Future.delayed(const Duration(seconds: 2));
    if(value != null){
      var user = jsonDecode(value);
      authController.userModel.value = UserModel.fromJson(user);
      Get.offAll(const BookingHistoryPage());
    }else{
      Get.offAll(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: ClipRRect(
            child: Image.asset('assets/logo.jpeg',fit: BoxFit.fill
              ,),
          ),
        ),
      ),
    );
  }
}
