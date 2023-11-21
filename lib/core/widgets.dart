  import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

showErrorSnack(title,message){
  Get.snackbar(title, message,backgroundColor: Colors.red,colorText: Colors.white);
  }
  showSuccessSnack(title,message){
    Get.snackbar(title, message,backgroundColor: Colors.green,colorText: Colors.white);
  }


  Future<File?> pickImage(ImageSource imgSource) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: imgSource);

      if (pickedFile != null) {
        return  File(pickedFile.path);
      }
      return null;

  }
