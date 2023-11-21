import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smile/core/widgets.dart';
import 'package:smile/data/apiclient/apimanager.dart';
import 'package:smile/data/models/bookingModel.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';


class BookingController extends GetxController {

  AuthController authController = Get.put(AuthController());

  Rx<List<BookingModel>> bookingList = Rx<List<BookingModel>>([]);
  RxBool loading = false.obs;
  RxBool loadingButton = false.obs;

  Rxn<File> selectedFile = Rxn<File>();
  Rxn<String> selectedImageURI = Rxn<String>();

  TextEditingController notesController = TextEditingController();

  getBookings() async {
    try{
      loading.value = true;
      var bookingListValue= await ApiClient().getBookings(headers: {"email":authController.userModel!.value!.email!});



      bookingList.value = bookingListValue;


      loading.value = false;
    }catch(e){
      loading.value = false;
    }
  }

  updateBooking(int id, String value) async {
    try{
      loading.value = true;
      await uploadImage();
      Get.back();
      var bookingListValue= await ApiClient().updateBookingStatus(headers: {"email":authController.userModel!.value!.email!},requestData: {
        "id" : id,
        "status":value,"image" : selectedImageURI.value,"drivernote" : notesController.text
      });


      loading.value = false;


      getBookings();


      showSuccessSnack("Updated","");
      selectedFile.value = null;
      selectedImageURI.value = null;
    }catch(e){
      Get.back();
      showErrorSnack("Error", e.toString());
      loading.value = false;
    }
  }

  getImage(){
    Get.defaultDialog(
      title: "CHOOSE FROM",
      content:  Row(
        children: [
         ElevatedButton(
            onPressed: () async {
              selectedFile.value = await pickImage(ImageSource.camera);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 5,
            ),
            child: Text('CAMERA'),
          ),
          ElevatedButton(
            onPressed: () async {
              selectedFile.value = await pickImage(ImageSource.gallery);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 5,
            ),
            child: Text('GALLERY'),
          ),
        ],
      )
    );
  }

  uploadImage() async {
    if(selectedFile.value == null){
      throw Exception("IMAGE NOT UPLOADED PLEASE TRY AGAIN");
    }
    var uri =  await ApiClient().uploadImage(selectedFile.value!);

    if(uri == null){
      throw Exception("IMAGE NOT UPLOADED PLEASE TRY AGAIN");
    }else{
      selectedImageURI.value = uri;
    }
  }



}
