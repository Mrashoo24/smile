  import 'package:flutter/material.dart';
import 'package:get/get.dart';

showErrorSnack(title,message){
  Get.snackbar(title, message,backgroundColor: Colors.red,colorText: Colors.white);
  }
  showSuccessSnack(title,message){
    Get.snackbar(title, message,backgroundColor: Colors.green,colorText: Colors.white);
  }
