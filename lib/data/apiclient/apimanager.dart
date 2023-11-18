
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:smile/core/widgets.dart';
import 'package:smile/data/models/bookingModel.dart';
import 'package:smile/data/models/userModel.dart';

import '../../core/errors/exceptions.dart';
import '../../core/network_info.dart';
import 'package:http/http.dart' as http;

class ApiClient extends GetConnect {
  var url = "https://smilecouriers.com.au/book/Driver";

  @override
  void onInit() {
    super.onInit();
    // httpClient.timeout = const Duration(seconds: 60);
  }

  ///method can be used for checking internet connection
  ///returns [bool] based on availability of internet
  Future isNetworkConnected() async {
    if (!await Get.find<NetworkInfo>().isConnected()) {
      throw NoInternetException('No Internet Found!');
    }
  }

  /// is `true` when the response status code is between 200 and 299
  ///
  /// user can modify this method with custom logics based on their API response
  bool _isSuccessCall(Response response) {
    return response.isOk;
  }

  /// Performs API call for https://nodedemo.dhiwise.co/device/api/v1/user/list
  ///
  /// Sends a POST request to the server's 'https://nodedemo.dhiwise.co/device/api/v1/user/list' endpoint
  /// with the provided headers and request data
  /// Returns a [PostListUserResp] object representing the response.
  /// Throws an error if the request fails or an exception occurs.
  Future<UserModel> loginUser({
    Map<String, String> headers = const {},
    Map requestData = const {},
  }) async {
    await isNetworkConnected();

    try {
      http.Response responseValue = await http.post(
        Uri.parse( '$url/apiLogin'),
        headers: headers,
        body: jsonEncode(requestData),
      );
      var response = jsonDecode(responseValue.body);
      if (response['status'] == 1 ) {
        return UserModel.fromJson(response['data']);
      } else {
        throw response != null
            ? response['message']
            : 'Something Went Wrong!';
      }
    } catch (error) {

      showErrorSnack("Error",error.toString());

      rethrow;
    }
  }

  Future<List<BookingModel>> getBookings({
    Map<String, String> headers = const {},
    Map requestData = const {},
  }) async {
    await isNetworkConnected();

    try {
      http.Response responseValue = await http.get(
        Uri.parse( '$url/apiDriverData'),
        headers: headers,
      );
      var response = jsonDecode(responseValue.body);
      if (response['status'] == 1 ) {
        List<BookingModel> modelList = [];

        for (final Map<String, dynamic> i in response['jobcards']) {
          // log('i : ' + i.toString());
          modelList.add(BookingModel.fromJson(i));
        }
        return modelList;
      } else {
        throw response != null
            ? response['message']
            : 'Something Went Wrong!';
      }
    } catch (error) {

      showErrorSnack("Error",error.toString());

      rethrow;
    }
  }

  Future<bool> updateBookingStatus({
    Map<String, String> headers = const {},
    Map requestData = const {},
  }) async {
    await isNetworkConnected();

    try {
      http.Response responseValue = await http.post(
        Uri.parse( '$url/apiUpdateStatus'),
        headers: headers,
        body: jsonEncode(requestData),
      );
      var response = jsonDecode(responseValue.body);
      if (response['status'] == 1 ) {
        return true;
      } else {
        throw response != null
            ? response['message']
            : 'Something Went Wrong!';
      }
    } catch (error) {

      showErrorSnack("Error",error.toString());

      rethrow;
    }
  }
}
