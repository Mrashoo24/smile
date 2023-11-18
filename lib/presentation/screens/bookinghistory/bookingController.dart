import 'package:get/get.dart';
import 'package:smile/core/widgets.dart';
import 'package:smile/data/apiclient/apimanager.dart';
import 'package:smile/data/models/bookingModel.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';


class BookingController extends GetxController {

  AuthController authController = Get.put(AuthController());

  Rx<List<BookingModel>> bookingList = Rx<List<BookingModel>>([]);
  RxBool loading = false.obs;
  RxBool loadingButton = false.obs;

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
      Get.back();
      var bookingListValue= await ApiClient().updateBookingStatus(headers: {"email":authController.userModel!.value!.email!},requestData: {
        "id" : id,
        "status":value
      });


      loading.value = false;


      getBookings();


      showSuccessSnack("Updated","");
    }catch(e){
      Get.back();
      loadingButton.value = false;
    }
  }

}
