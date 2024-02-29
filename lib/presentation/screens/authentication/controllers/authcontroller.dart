import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile/data/apiclient/apimanager.dart';
import 'package:smile/data/models/userModel.dart';
import 'package:smile/presentation/screens/authentication/loginscreen.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingh_history_screen.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rxn<UserModel> userModel = Rxn<UserModel>();
  RxBool loading = false.obs;


  loginUser() async {
    try{
      loading.value = true;
      UserModel userModelValue = await ApiClient().loginUser(requestData: {'email':emailController.text.toString(),"password":passwordController.text});

      var pref  = await SharedPreferences.getInstance();

      pref.setString('user', jsonEncode(userModelValue.toJson()));


      userModel.value = userModelValue;


      loading.value = false;
      Get.to(const BookingHistoryPage());
    }catch(e){
      loading.value = false;
    }
  }

  logoutUser() async {

    var pref  = await SharedPreferences.getInstance();

    pref.clear();
    userModel.value = null;

    Get.offAll(const LoginScreen());

  }
}
