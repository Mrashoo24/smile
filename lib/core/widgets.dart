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

    final pickedFile = await picker.pickImage(source: imgSource,imageQuality: 30);

      if (pickedFile != null) {
        return  File(pickedFile.path);
      }
      return null;

  }
  Future<List<File>?> pickMultiImage(ImageSource imgSource) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickMultiImage(imageQuality: 30);

    return pickedFile.map((e) =>  File(e.path)).toList();

  }

  RichText buildDataText(BuildContext context, key, value) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle
            .of(context)
            .style,
        children: <TextSpan>[
          TextSpan(
            text: '$key: ',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

