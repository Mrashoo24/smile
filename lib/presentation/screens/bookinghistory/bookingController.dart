import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:smile/core/widgets.dart';
import 'package:smile/data/apiclient/apimanager.dart';
import 'package:smile/data/models/bookingModel.dart';
import 'package:smile/data/models/notesModel.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';


class LocationModel {
  double latitude;
  double longitude;

  LocationModel(this.latitude, this.longitude);
}


class BookingController extends GetxController {

  AuthController authController = Get.put(AuthController());

  Rx<List<BookingModel>> bookingList = Rx<List<BookingModel>>([]);
  Rx<List<NotesModel>> noteList =     Rx<List<NotesModel>>([]);

  RxBool loading = false.obs;
  RxBool loadingButton = false.obs;

  Rxn<File> selectedFile = Rxn<File>();
  Rxn<String> selectedImageURI = Rxn<String>();

  TextEditingController notesController = TextEditingController();

  Rxn<List<File>> selectedFileList =   Rxn<List<File>>([]);
  Rxn<List<String>> selectedImageURIList =   Rxn<List<String>> ([]);


  RxBool notesloading = false.obs;

  double calculateDistance(LocationModel location1, LocationModel location2) {
  const earthRadius = 6371.0; // Earth's radius in kilometers

  final lat1 = location1.latitude * pi / 180.0;
  final lon1 = location1.longitude * pi / 180.0;
  final lat2 = location2.latitude * pi / 180.0;
  final lon2 = location2.longitude * pi / 180.0;

  final dlat = lat2 - lat1;
  final dlon = lon2 - lon1;

  final a = sin(dlat / 2) * sin(dlat / 2) +
  cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final distance = earthRadius * c;
  return distance;
  }

  List<BookingModel> sortLocationsByDistance(List<BookingModel> locations, LocationModel targetLocation) {




  locations.sort((a, b) {
  final distanceA = calculateDistance(targetLocation, a.location!);
  final distanceB = calculateDistance(targetLocation, b.location!);
  return distanceA.compareTo(distanceB);
  });

  return locations;
  }


  Future<LocationModel> geoCodingTest(String address) async {
    const String googelApiKey = 'AIzaSyC2qLMdCcdT2qYnzFJOMNL7ynFv1DwSgEc';
    final bool isDebugMode = true;
    final api = GoogleGeocodingApi(googelApiKey, isLogged: isDebugMode);

    final searchResults = await api.search(
      address,
      language: 'en',
    );

    print("checkAddress = ${searchResults.results.first.geometry!.location.lat} ${searchResults.results.first.geometry!.location.lng}");

    return LocationModel(searchResults.results.first.geometry!.location.lat, searchResults.results.first.geometry!.location.lng);

  }

  Future<void> _requestLocationPermission() async {
    final location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    getCurrentLocation();
  }

  Future<LocationModel?> getCurrentLocation() async {
    try {
      final location = Location();
     var  _currentLocation = await location.getLocation();


     return LocationModel(_currentLocation.latitude!, _currentLocation.longitude!);

    } catch (e) {
      print("Error: $e");
      return null;
    }
  }


  getBookings() async {
    try{
      loading.value = true;

      var bookingListValue= await ApiClient().getBookings(headers: {"email":authController.userModel.value!.email!});

      List<BookingModel> bookingList1 = [];
      Future.forEach(bookingListValue,(element) async {
        var newValue = element;
       LocationModel location =  await geoCodingTest(element.toAddress!.replaceAll("-//-", ""));
        newValue.location = location;
        bookingList1.add(newValue);
      });

      var currentLocation = await getCurrentLocation();

      bookingList.value =   sortLocationsByDistance(bookingList1, currentLocation!);

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
      var bookingListValue= await ApiClient().updateBookingStatus(headers: {"email":authController.userModel.value!.email!},requestData: {
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
              foregroundColor: Colors.white, backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 5,
            ),
            child: const Text('CAMERA'),
          ),
          ElevatedButton(
            onPressed: () async {
              selectedFile.value = await pickImage(ImageSource.gallery);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 5,
            ),
            child: const Text('GALLERY'),
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
  uploadImageBulk() async {
    if(selectedFileList.value == null){
      throw Exception("IMAGE NOT UPLOADED PLEASE TRY AGAIN");
    }
    await Future.forEach(selectedFileList.value!,(element) async {
      var uri = await ApiClient().uploadImage(element);
      selectedImageURIList.value!.add(uri!);

    });


    if(selectedImageURIList.value == null || selectedImageURIList.value!.isEmpty){
      throw Exception("IMAGE NOT UPLOADED PLEASE TRY AGAIN");
    }
  }

  getImageBulk(){
    Get.defaultDialog(
        title: "CHOOSE FROM",
        content:  Row(
          children: [
            // ElevatedButton(
            //   onPressed: () async {
            //     Get.back();
            //    var pickedFile =  await pickImage(ImageSource.camera);
            //    if(pickedFile != null){
            //       selectedFileList.value!.add(pickedFile);
            //       selectedFileList.value = selectedFileList.value;
            //     }
            //
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.red,
            //     onPrimary: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30.0),
            //     ),
            //     elevation: 5,
            //   ),
            //   child: Text('CAMERA'),
            // ),
             ElevatedButton(
              onPressed: () async {
                Get.back();
                selectedFileList.value = await pickMultiImage(ImageSource.gallery);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 5,
              ),
              child: const Text('GALLERY'),
            ),
          ],
        )
    );
  }




  updateNotes() async {

    try{
      notesloading.value = true;
      await uploadImageBulk();

      var bookingListValue= await ApiClient().updateNotes(requestData: {
        "driver" : authController.userModel.value!.id!,"image" : selectedImageURIList.value,"note" : notesController.text,"lat":"1","long":"1","date": DateTime.now().toLocal().toString().split(" ")[0]
      });
      //
      // var pref = Get.put<PrefUtils>(PrefUtils());
      // await pref.init();
      getNotes();

      // noteList.value.add(
      //        NotesModel.fromJson ({
      //   "driver": authController.userModel!.value!.id!,
      //   "image": selectedImageURIList.value.toString(),
      //   "note": notesController.text, "date" : DateTime.now().toLocal().toString(),"lat":"1","long":"1"
      // })
      // );
      // if(bookingListValue){
      // pref.setString("notes", jsonEncode(noteList.value));
      // }

      notesloading.value = false;


      showSuccessSnack("Updated","");
      selectedFile.value = null;
      selectedImageURI.value = null;
      notesController.clear();
      Get.back();
    }catch(e){
      Get.back();
      showErrorSnack("Error", e.toString());
      notesloading.value = false;
    }
  }


  getNotes() async {

    notesloading.value = true;
        noteList.value = await ApiClient().getNotes(headers: {"id":authController.userModel.value!.id!});
    notesloading.value = false;
    }


  }





