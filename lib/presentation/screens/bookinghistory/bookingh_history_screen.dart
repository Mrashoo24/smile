
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/data/models/bookingModel.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingController.dart';
import 'package:smile/presentation/screens/notehistory/noteshistory.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets.dart';
import '../addbooking/addBookings.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  var controller = Get.put(BookingController());
  var authController = Get.put(AuthController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    controller.getBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
       await controller.getBookings();
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Booking History'),
          backgroundColor: Colors.red,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(Icons.menu)),
        ),
        drawer: SafeArea(
          child: Drawer(
            width: Get.width * 0.4,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Text(authController.userModel.value!.firstName!,
                    style: const TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3),),
                  const SizedBox(height: 20,),
                  ListTile(title: const Text("Notes"), onTap: () {
                    Get.to(const NotesHistoryPage());
                  }, leading: const Icon(Icons.newspaper_outlined)),
                  const SizedBox(height: 20,),
                  ListTile(title: const Text("Logout"), onTap: () {
                    authController.logoutUser();
                  }, leading: const Icon(Icons.logout))
                  , const SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(

            onPressed: (){
          Get.to(AddBooking());
        },

          backgroundColor: Colors.red, // Set the background color to red
          child: Icon(
            Icons.add, // Assuming you want to use the "add" icon
            color: Colors.black, // Set the icon color to black
          ),

        ),
        body: GetX<BookingController>(
          init: controller,
          builder: (controller) {
            return controller.loading.value ? const Center(
              child: CircularProgressIndicator(),) : ListView.builder(
              itemCount: controller.bookingList.value.length,
              itemBuilder: (context, index) {
                BookingModel booking = controller.bookingList.value[index];

                return Card(
                  margin: const EdgeInsets.all(16.0),
                  child: ExpansionTile(
                    title: Column(
                      children: [
                        buildDataText(
                            context, 'Booking ID', '${booking.id}'),
                        buildDataText(
                            context,booking.jobcard == 'Pick Up' ? 'From Address' : 'To Address:', '\n${booking.jobcard == 'Pick Up' ?booking.fromAddress : booking.toAddress}'),
                        const SizedBox(height: 10,)
                      ],
                    ),
                    subtitle: buildDataText(
                        context, 'Booking Type', booking.jobcard),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                return WillPopScope(
                                  onWillPop: ()async {
                                    controller.selectedFile.value = null;
                                    controller.selectedImageURI.value = null;
                                    controller.notesController.clear();
                                    Get.back();
                                    return false;
                                  },
                                  child: Dialog(
                                    child: GetX<BookingController>(
                                      builder: (controller
                                          ) {
                                        return SingleChildScrollView(
                                          child: Container(
                                            height: 400,
                                            width: Get.width * 0.7,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 40, horizontal: 10),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Center(child: IconButton(onPressed: (){
                                                    controller.selectedFile.value = null;
                                                    controller.selectedImageURI.value = null;
                                                    controller.notesController.clear();
                                                    Get.back();
                                                  }, icon: Icon(Icons.close)),),
                                                  const Text("SELECT STATUS",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold),),

                                                  const Text("CAPTURE IMAGE"),
                                                  Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        controller.selectedFile
                                                            .value == null
                                                            ? const Text(
                                                            'No image selected.')
                                                            : Image.file(
                                                          controller.selectedFile
                                                              .value!,
                                                          height: 150.0,
                                                        ),
                                                        const SizedBox(height: 20.0),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            controller.getImage();
                                                          },
                                                          child: const Text(
                                                              'Select Image'),
                                                        ),
                                                        const SizedBox(height: 20.0),
                                                        TextFormField(
                                                          controller: controller
                                                              .notesController,
                                                          decoration: const InputDecoration(
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .red)
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .red)
                                                              ),
                                                              label: Text("Notes")
                                                          ),

                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  if(booking.jobcard == "Pick Up")
                                                  buildInkWell(
                                                      "Picked Up", booking),
                                                  if(booking.jobcard != "Pick Up")
                                                  buildInkWell(
                                                      "Successfully Delivered",
                                                      booking),
                                                  buildInkWell(
                                                      "Cancelled", booking),


                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                              // Get.defaultDialog(title: "Select Status",
                              //   content:
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.red,
                            ),
                            child: Text(booking.status!,
                              style: const TextStyle(fontSize: 12,),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                        const SizedBox(width: 4,),
                        InkWell(
                          onTap: () async {

                           var curretnLocatiomn =  await controller.getCurrentLocation();

                           print("https://www.google.com/maps/dir/?api=1&origin=${curretnLocatiomn!.latitude},${curretnLocatiomn!.longitude}&destination=${booking.jobcard == "Pick Up" ? booking.locationFrom!.latitude : booking.toLocation!.latitude},${booking.jobcard == "Pick Up" ? booking.locationFrom!.longitude : booking.toLocation!.longitude}");
                            if (!await launchUrl(Uri.parse("https://www.google.com/maps/dir/?api=1&origin=${curretnLocatiomn!.latitude},${curretnLocatiomn!.longitude}&destination=${booking.jobcard == "Pick Up" ? booking.locationFrom!.latitude : booking.toLocation!.latitude},${booking.jobcard == "Pick Up" ? booking.locationFrom!.longitude : booking.toLocation!.longitude}"))) {
                            throw Exception('Could not launch');
                            }
                          },

                            child: const Icon(Icons.location_on))
                      ],
                    ),
                    children: [
                      ListTile(
                        title: buildDataText(
                            context, 'Emp Code', booking.empId),
                      ),
                      ListTile(
                        title: buildDataText(context, 'Booking ID', booking.id),
                      ),
                      ListTile(
                        title: buildDataText(context, 'Booking Date',
                            booking.date),
                      ),
                      ListTile(
                        title: buildDataText(context, 'Booking Time',
                            booking.timestampp),
                      ),
                      ListTile(
                        title: buildDataText(context, 'Company/Lab Name',
                            booking.companyname),
                      ),
                      ListTile(
                        title: buildDataText(context, 'Notes', booking.notes),
                      ),
                      ListTile(
                        title: buildDataText(context, 'From Address',
                            booking.fromAddress),
                      ),
                      ListTile(
                        title: buildDataText(context, 'To Address',
                            booking.toAddress),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  buildInkWell(title, BookingModel booking) {
    return InkWell(
      onTap: () {
        controller.updateBooking(int.parse(booking.id!), title);
      },
      child: Card(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.red
            ),
            width: double.infinity,
            child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: const TextStyle(color: Colors.white),),
            )),
          )
      ),
    );
  }

}