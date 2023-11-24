import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/data/models/bookingModel.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingController.dart';

class BookingHistoryPage extends StatefulWidget {
  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  var controller = Get.put(BookingController());
  var authController = Get.put(AuthController());

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
          title: Text('Booking History'),
          backgroundColor: Colors.red,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(Icons.menu)),
        ),
        drawer: SafeArea(
          child: Drawer(
            width: Get.width * 0.4,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Text(authController.userModel.value!.firstName!,
                    style: TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3),),
                  SizedBox(height: 20,),
                  ListTile(title: Text("Logout"), onTap: () {
                    authController.logoutUser();
                  }, leading: Icon(Icons.logout))
                ],
              ),
            ),
          ),
        ),
        body: GetX<BookingController>(
          init: controller,
          builder: (controller) {
            return controller.loading.value ? Center(
              child: CircularProgressIndicator(),) : ListView.builder(
              itemCount: controller.bookingList.value!.length,
              itemBuilder: (context, index) {
                BookingModel booking = controller.bookingList.value![index];

                return Card(
                  margin: EdgeInsets.all(16.0),
                  child: ExpansionTile(
                    title: buildDataText(
                        context, 'Booking ID', '${booking.id}'),
                    subtitle: buildDataText(
                        context, 'Booking Type', booking.jobcard),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(context: context, builder: (context) {
                                return Dialog(
                                  child: GetX<BookingController>(
                                    builder: (controller
                                        ) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          height: 400,
                                          width: Get.width * 0.7,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 40, horizontal: 10),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text("SELECT STATUS",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold),),

                                                Text("CAPTURE IMAGE"),
                                                Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      controller.selectedFile
                                                          .value == null
                                                          ? Text(
                                                          'No image selected.')
                                                          : Image.file(
                                                        controller.selectedFile
                                                            .value!,
                                                        height: 150.0,
                                                      ),
                                                      SizedBox(height: 20.0),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          controller.getImage();
                                                        },
                                                        child: Text(
                                                            'Select Image'),
                                                      ),
                                                      SizedBox(height: 20.0),
                                                      TextFormField(
                                                        controller: controller
                                                            .notesController,
                                                        decoration: InputDecoration(
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
                                                buildInkWell(
                                                    "Picked Up", booking),
                                                buildInkWell(
                                                    "On The Way", booking),
                                                buildInkWell(
                                                    "Successfully Delivered",
                                                    booking),
                                                buildInkWell(
                                                    "Cancelled", booking),
                                                buildInkWell(
                                                    "Address not Found",
                                                    booking),

                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              });
                              // Get.defaultDialog(title: "Select Status",
                              //   content:
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                            ),
                            child: Text(booking.status!,
                              style: TextStyle(fontSize: 12,),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                        SizedBox(width: 4,),
                        Icon(Icons.location_on)
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
            child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(color: Colors.white),),
            )),
            decoration: BoxDecoration(
                color: Colors.red
            ),
            width: double.infinity,
          )
      ),
    );
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
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}